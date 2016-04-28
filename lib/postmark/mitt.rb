module Postmark
  class Mitt
    def initialize(json)
      @raw = json
      @source = MultiJson.decode(json)
    end

    attr_reader :raw, :source

    def inspect
      "<Postmark::Mitt: #{message_id}>"
    end

    def subject
      source["Subject"]
    end

    def from
      source["From"].gsub('"', '')
    end

    def from_email
      source["FromFull"]["Email"] || from
    end

    def from_name
      source["FromFull"]["Name"] || from
    end

    def to
      source["To"].gsub('"', '')
    end

    def to_full
      source["ToFull"] || []
    end

    def to_email
      to_full.any? ? to_full.first["Email"] : to
    end

    def to_name
      to_full.any? ? to_full.first["Name"] : to
    end


    def bcc
      source["Bcc"]
    end

    def bcc_email
      source["BccFull"]["Email"] || bcc
    end

    def bcc_name
      source["BccFull"]["Name"] || bcc
    end

    def cc
      source["Cc"]
    end

    def cc_email
      source["CcFull"]["Email"] || cc
    end

    def cc_name
      source["CcFull"]["Name"] || cc
    end

    def reply_to
      source["ReplyTo"]
    end

    def html_body
      source["HtmlBody"]
    end

    def text_body
      source["TextBody"]
    end

    def mailbox_hash
      source["MailboxHash"]
    end

    def tag
      source["Tag"]
    end

    def headers
      @headers ||= source["Headers"].inject({}){|hash,obj| hash[obj["Name"]] = obj["Value"]; hash}
    end

    def message_id
      source["MessageID"]
    end

    def attachments
      @attachments ||= begin
        raw_attachments = source["Attachments"] || []
        AttachmentsArray.new(raw_attachments.map{|a| Attachment.new(a)})
      end
    end

    def has_attachments?
      !attachments.empty?
    end

    class Attachment
      def initialize(attachment_source)
        @source = attachment_source
      end
      attr_accessor :source

      def content_type
        source["ContentType"]
      end

      def file_name
        source["Name"]
      end

      def read
        tempfile = MittTempfile.new(file_name, content_type)
        if size > 0
          tempfile.write(Base64.decode64(source["Content"]))
        end
        tempfile
      end

      def size
        source["ContentLength"].to_i
      end
    end

    class AttachmentsArray < Array
      def sorted
        @sorted ||= self.sort{|x,y|x.size <=> y.size}
      end

      def largest
        sorted.last
      end

      def smallest
        sorted.first
      end
    end
  end

  class MittTempfile < Tempfile
    def initialize(basename, content_type, tmpdir=Dir::tmpdir)
      basename = basename.gsub(/[\/\\]/, "-")
      if Postmark.ruby19?
        super(basename, tmpdir, :encoding => 'ascii-8bit')
      else
        super(basename, tmpdir)
      end
      @basename = basename
      @content_type = content_type
    end

    # the content type of the "uploaded" file
    attr_accessor :content_type

    def original_filename
      @basename || file.basename(path)
    end
  end

  def self.ruby19?
    RUBY_VERSION > "1.9"
  end
end
