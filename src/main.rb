require_relative 'monopondSOAPClient'

class Main

  @wsseToken = WSSEToken.new('username', 'password')

  @client = MonopondSOAPClientV2.new(@wsseToken, MPENV::LOCAL2)
  printf("%s \n \n", @client.client.operations)

  #sample for send fax
  @documents = []
  @document = MonopondDocument.new(nil, nil)
  @document.documentRef = 'doc-ref-sample-doc-8'
  #@document.documentRef = 'doc-ref-sample-tiff-1'
  @document.ditheringTechnique = "normal";


  @docMergeField1 = MonopondDocMergeFieldKey.new("text1", "NewText1");
  @docMergeField2 = MonopondDocMergeFieldKey.new("text2", "NewText2");

  @docMergeFields = [];
  @docMergeFields << @docMergeField1
  @docMergeFields << @docMergeField2

  @stampMergeFieldKey1 = MonopondStampMergeFieldKey.new(0, 1);
  @stampMergeFieldKey2 = MonopondStampMergeFieldKey.new(2, 3);

  @stampMergeFieldTextValue1 = MonopondStampMergeFieldTextValue.new("text1", "Ubuntu-Bold", 14);

  @stampMergeFieldTextValue2 = MonopondStampMergeFieldTextValue.new("text2", "Courier", 13);

  @stampMergeFieldImageValue1 = MonopondStampMergeFieldImageValue.new
  @stampMergeFieldImageValue1.fileName = "logo_stamp1.png";
  @stampMergeFieldImageValue1.fileData = "somebase64Data"
  @stampMergeFieldImageValue1.width = 300
  @stampMergeFieldImageValue1.height = 300

  @stampMergeFieldImageValue2 = MonopondStampMergeFieldImageValue.new
  @stampMergeFieldImageValue2.fileName = "logo_stamp2.png";
  @stampMergeFieldImageValue2.fileData = "somebase64Data"
  @stampMergeFieldImageValue2.width = 400
  @stampMergeFieldImageValue2.height = 400

  @stampMergeField1 = MonopondStampMergeField.new;
  @stampMergeField1.key = @stampMergeFieldKey1
  @stampMergeField1.textValue = @stampMergeFieldTextValue1;
  @stampMergeField1.imageValue = @stampMergeFieldImageValue1;

  @stampMergeField2 = MonopondStampMergeField.new;
  @stampMergeField2.key = @stampMergeFieldKey2
  @stampMergeField2.textValue = @stampMergeFieldTextValue2;
  @stampMergeField2.imageValue = @stampMergeFieldImageValue2;

  @stampMergeFields = []
  @stampMergeFields << @stampMergeField1;
  @stampMergeFields << @stampMergeField2;

  @document.docMergeData = @docMergeFields
  #@document.stampMergeData = @stampMergeFields
  @documents << @document

  #@document2 = MonopondDocument.new('test2.txt','VGhpcyBpcyBhIGZheA==')
  #@documents << @document2

  @faxMessages = []
  @faxMessage = MonopondFaxMessage.new('msg-ref-1', '6011111111')
  @faxMessage.sendFrom = 'Test Fax'
  @faxMessage.resolution = 'normal'
  @faxMessage.headerFormat = "%a %b %d %H:%M %Y|";
  @faxMessage.mustBeSentBeforeDate = "2012-07-17T19:27:23+08:00";
  @faxMessage.maxFaxPages = 2;
  @faxMessage.cLI = "2";  

  @faxMessage.documents = @documents
  @faxMessages << @faxMessage

  @faxMessage1 = MonopondFaxMessage.new('msg-ref-2', '6011111111')
  @faxMessage1.sendFrom = 'Test Fax2'
  @faxMessage1.resolution = 'normal'
  @faxMessage1.documents = @documents
  @faxMessages << @faxMessage1

  @request = MonopondSendFaxRequest.new(@faxMessages, @documents)
  @request.resolution = 'fine'
  @request.broadcastRef = "broadcast-ref-1"
  @request.sendRef = "send-ref-1"
  @request.sendFrom = "someone";
  #@response = @client.sendFax(@request)

  #sample for fax status
  @request = MonopondFaxStatusRequest.new
  @request.verbosity = "all"
  @request.messageRef= "msg-ref-1"
  #@response = @client.faxStatus(@request)

  #sample for stop fax
  @request = MonopondStopFaxRequest.new
  @request.sendRef= "send-ref-1"
  #@response = @client.stopFax(@request)

  #sample for pause fax
  @request = MonopondPauseFaxRequest.new
  @request.messageRef= "msg-ref-1"
  #@response = @client.pauseFax(@request)

  #sample for resume fax
  @request = MonopondResumeFaxRequest.new
  @request.broadcastRef= "broadcast-ref-1"
  #@response = @client.resumeFax(@request)

  @request = MonopondSaveFaxDocumentRequest.new
  @request.documentRef = "doc-ref-some-png";
  @request.fileName = "logo_stamp1.png";
  @request.fileData = "somebase64Data"
  #@response = @client.saveFaxDocument(@request)

  @request = MonopondDeleteFaxDocumentRequest.new
  @request.documentRef = "doc-ref-some-png"
  #@response = @client.deleteFaxDocument(@request)

  #@request = MonopondFaxDocumentPreviewRequest.new('doc-ref-sample-doc-8');
  @request = MonopondFaxDocumentPreviewRequest.new('doc-ref-some-tiff-testt');
  #@request.docMergeData = @docMergeFields
  #@request.stampMergeData = @stampMergeFields
  #@request.resolution = "FINE";
  #@request.ditheringTechnique = "DARKEN_EXTRA";
  #@response = @client.faxDocumentPreview(@request)
end
