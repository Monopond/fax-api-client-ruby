require_relative 'monopondSOAPClient'

class Main

  @wsseToken = WSSEToken.new('timtest', 'gnome4life')

  @client = MonopondSOAPClientV2.new(@wsseToken, MPENV::LOCAL)
  printf("%s \n \n", @client.client.operations)

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
  @faxMessages << @faxMessage1

  @request = MonopondSendFaxRequest.new(@faxMessages, @documents)
  @request.resolution = 'fine'
  @request.broadcastRef = "broadcast-ref-1"
  @response = @client.sendFax(@request)

  #print @response.body[:send_fax_response][:fax_messages]

end