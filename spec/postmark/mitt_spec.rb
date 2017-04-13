require File.expand_path(File.dirname(__FILE__) + '/..' + '/spec_helper')

describe Postmark::Mitt do
  let(:mitt) do
    Postmark::Mitt.new(read_fixture)
  end

  it "should have a subject" do
    mitt.subject.should == "Hi There"
  end

  it "should have a html_body" do
    mitt.html_body.should == "<p>We no speak americano</p>"
  end

  it "should have a text_body" do
    mitt.text_body.should == "\nThis is awesome!\n\n"
  end

  it "should be to someone" do
    mitt.to.should == "Api Hash <api-hash@inbound.postmarkapp.com>"
  end

  it "should pull out the to_name" do
    mitt.to_name.should == "Api Hash"
  end

  it "should pull out the to_email" do
    mitt.to_email.should == "api-hash@inbound.postmarkapp.com"
  end

  it "should be from someone" do
    mitt.from.should == "Bob Bobson <bob@bob.com>"
  end

  it "should pull out the from_email" do
    mitt.from_email.should == "bob@bob.com"
  end

  it "should pull out the from_name" do
    mitt.from_name.should == "Bob Bobson"
  end

  it "should have a bcc" do
    mitt.bcc.should == "FBI <hi@fbi.com>"
  end

  it "should pull out the bcc_email" do
    mitt.bcc_email.should == "hi@fbi.com"
  end

  it "should pull out the bcc_name" do
    mitt.bcc_name.should == "FBI"
  end

  it "should have a cc" do
    mitt.cc.should == "Your Mom <hithere@hotmail.com>"
  end

  it "should pull out the cc_email" do
    mitt.cc_email.should == "hithere@hotmail.com"
  end

  it "should pull out the cc_name" do
    mitt.cc_name.should == "Your Mom"
  end

  it "should have a reply_to" do
    mitt.reply_to.should == "new-comment+sometoken@yeah.com"
  end

  it "should have a mailbox_hash" do
    mitt.mailbox_hash.should == 'moitoken'
  end

  it "should have a tag" do
    mitt.tag.should == 'yourit'
  end

  it "should have a message_id" do
    mitt.message_id.should == "a8c1040e-db1c-4e18-ac79-bc5f64c7ce2c"
  end

  it "should have headers" do
    mitt.headers["Date"].should =="Thu, 31 Mar 2011 12:01:17 -0400"
  end

  it "handles null headers" do
    mitt.stub(:source).and_return({"Headers" => nil})
    mitt.headers.should == {}
  end

  it "should have an attachment" do
    mitt.attachments.size.should == 2
  end

  it "should have attachment objects" do
    mitt.attachments.first.class.name.should == 'Postmark::Mitt::Attachment'
  end

  it "should know if it has attachments" do
    mitt.attachments.should_not be_empty
    mitt.should have_attachments
    mitt.stub!(:attachments).and_return([])
    mitt.should_not have_attachments
  end

  describe "#attachments.largest" do
    it "should return the attachment with the largest content length" do
      largest = mitt.attachments.largest
      largest.file_name.should == "chart.png"
      largest.size.should == 2000
    end
  end

  describe "#attachments.smallest" do
    it "should return the attachment with the smallest content length" do
      smallest = mitt.attachments.smallest
      smallest.file_name.should == "chart2.png"
      smallest.size.should == 1000
    end
  end

  describe Postmark::Mitt::Attachment do
    let(:attachment) do
      mitt.attachments.first
    end

    it "should have a content_type" do
      attachment.content_type.should == 'image/png'
    end

    it "should have a file_name" do
      attachment.file_name.should == 'chart.png'
    end

    describe "read" do
      it "should read the content" do
        attachment.read.class.name.should == "Postmark::MittTempfile"
      end

      it "should have a content_type" do
        attachment.read.content_type.should == 'image/png'
      end

      it "should have a original_filename" do
        attachment.read.original_filename.should == 'chart.png'
      end

      it "should not blow up with a zero content length and no source" do
        attachment = ::Postmark::Mitt::Attachment.new({"Name"=>"logo.gif",
                                          "ContentType"=>"image/gif",
                                          "ContentID"=>"logo.gif",
                                          "ContentLength"=>0})
        expect {
          attachment.read.read
        }.to_not raise_error
      end

      it "should not blow up with a nil content length" do
        attachment = ::Postmark::Mitt::Attachment.new({"Name"=>"logo.gif",
                                          "ContentType"=>"image/gif",
                                          "ContentID"=>"logo.gif",
                                          "ContentLength"=>nil})
        expect {
          attachment.read.read
        }.to_not raise_error
      end
    end

    it "should have a size" do
      attachment.size.should == 2000
    end
  end

  describe ::Postmark::MittTempfile do
    it "should not explode with path chars in the name" do
      expect {
        ::Postmark::MittTempfile.new("file/with/../path", "text/csv")
      }.to_not raise_error
    end

    it "should escape path chars" do
      instance = ::Postmark::MittTempfile.new("file/with/../path", "text/csv")
      instance.path.should include("file-with-..-path")
    end
  end
end
