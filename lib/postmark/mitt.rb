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
      if match = from.match(/^.+<(.+)>$/)
        match[1].strip
      else
        from
      end
    end

    def from_name
      if match = from.match(/(^.+)<.+>$/)
        match[1].strip
      else
        from
      end
    end

    def to
      source["To"]
    end

    def bcc
      source["Bcc"]
    end

    def cc
      source["Cc"]
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
        raw_attachments.map{|a| Attachment.new(a)}
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
        Base64.decode64(source["Content"])
      end

      def size
        source["ContentLength"]
      end
    end
  end
end
