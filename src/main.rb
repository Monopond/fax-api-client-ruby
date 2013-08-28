require_relative 'monopondSOAPClient'

class Main

  @wsseToken = WSSEToken.new('username', 'password')

  @client = MonopondSOAPClientV2.new(@wsseToken, MPENV::PRODUCTION)
  printf("%s \n \n", @client.client.operations)

  #sample for send fax
  @documents = []
  @document = MonopondDocument.new('test.txt','VGhpcyBpcyBhIGZheA==')
  @documents << @document

  @document2 = MonopondDocument.new('test2.txt','VGhpcyBpcyBhIGZheA==')
  @documents << @document2

  @faxMessages = []
  @faxMessage = MonopondFaxMessage.new('msg-ref-1', '6011111111')
  @faxMessage.sendFrom = 'Test Fax'
  @faxMessage.resolution = 'normal'
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
  @response = @client.sendFax(@request)

  #sample for fax status
  @request = MonopondFaxStatusRequest.new
  @request.verbosity = "all"
  @request.messageRef= "msg-ref-1"
  @response = @client.faxStatus(@request)

  #sample for stop fax
  @request = MonopondStopFaxRequest.new
  @request.sendRef= "send-ref-1"
  @response = @client.stopFax(@request)

  #sample for pause fax
  @request = MonopondPauseFaxRequest.new
  @request.verbosity = "send"
  @request.messageRef= "msg-ref-1"
  @response = @client.pauseFax(@request)

  #sample for resume fax
  @request = MonopondResumeFaxRequest.new
  @request.verbosity = "all"
  @request.broadcastRef= "broadcast-ref-1"
  @response = @client.resumeFax(@request)
end
