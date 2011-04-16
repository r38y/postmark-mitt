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
    mitt.to.should == "api-hash@inbound.postmarkapp.com"
  end

  it "should be from someone" do
    mitt.from.should == "Bob Bobson <bob@bob.com>"
  end

  it "should pull out the from_email" do
    mitt.from_email.should == "bob@bob.com"
  end

  it "should have a bcc" do
    mitt.bcc.should == "FBI <hi@fbi.com>"
  end

  it "should have a cc" do
    mitt.cc.should == "Your Mom <hithere@hotmail.com>"
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

  it "should have an attachment" do
    mitt.attachments.size.should == 1
  end

  it "should have attachment objects" do
    mitt.attachments.first.class.name.should == 'Postmark::Mitt::Attachment'
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

    it "should read the content" do
      attachment.read.should_not be_empty
    end

    it "should have a size" do
      attachment.size.should == "NYI"
    end
  end
end
