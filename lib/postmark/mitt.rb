module Postmark
  class Mitt
    VERSION = "0.0.1"

    def initialize(json)
      @raw = json
      @source = JSON.parse(json)
    end

    attr_reader :raw, :source

    def inspect
      "<Postmark::Mitt: #{message_id}>"
    end

    def subject
      source["Subject"]
    end

    def from
      source["From"].gsub('"')
    end

    def from_email
      if match = from.match(/^.+<(.+)>$/)
        match[1]
      else
        from_email
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
        Base64.decode(source["Content"])
      end

      def size
        "NYI"
      end
    end
  end
end
