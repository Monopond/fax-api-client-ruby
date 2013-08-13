require 'rubygems'
require 'builder'
require 'savon'

class MonopondSOAPClientV2
  attr_accessor :wsdl, :wssetoken, :client
  def initialize (wssetoken, wsdl)
    @wssetoken = wssetoken
    @wsdl = wsdl
    @client = Savon.client(wsdl: @wsdl,
        wsse_auth: [@wssetoken.username, @wssetoken.password],
        env_namespace: :soapenv,
        namespace:'https://api.monopond.com/fax/soap/v2', namespace_identifier: :v2,
        pretty_print_xml: true)

  end

  class SendFaxRequestEnvelope
    def to_s(sendFaxRequest, wsse)
      @xml = Builder::XmlMarkup.new
      @xml.tag!("soapenv:Envelope",
        "xmlns:soapenv" => "http://schemas.xmlsoap.org/soap/envelope/",
        "xmlns:wsse" => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd",
        "xmlns:v2" => "https://api.monopond.com/fax/soap/v2"
        ) {
        @xml.tag!("soapenv:Header") {
          @xml.tag!("wsse:Security", "soapenv:mustUnderstand" => "1") {
            @xml.tag!("wsse:UsernameToken") {
              @xml.tag!("wsse:Username"){ @xml.text! wsse.username }
              @xml.tag!("wsse:Password"){ @xml.text! wsse.password }
            }
          }
        }
        @xml.tag!("soapenv:Body") {
          @xml.tag!("v2:SendFaxRequest"){
            @xml.Documents {
              for document in sendFaxRequest.documents
                @xml.Document{ |doc|
                  doc.FileName(document.fileName);
                  doc.FileData(document.fileData);
                  unless document.order.nil?
                    doc.Order(document.order);
                  end
                }
              end
            }

            @xml.FaxMessages {
              for faxMessage in sendFaxRequest.faxMessages
                @xml.FaxMessage{ |fax|
                  fax.MessageRef(faxMessage.messageRef)
                  fax.SendTo(faxMessage.sendTo)

                  unless faxMessage.documents.nil?
                    @xml.Documents {
                      for document in faxMessage.documents
                        @xml.Document{ |doc|
                          doc.FileName(document.fileName);
                          doc.FileData(document.fileData);
                          unless document.order.nil?
                            doc.Order(document.order);
                          end
                        }
                      end
                    }
                  end

                  unless faxMessage.sendFrom.nil?
                    @xml.SendFrom(faxMessage.sendFrom)
                  end

                  unless faxMessage.resolution.nil?
                    @xml.Resolution(faxMessage.resolution)
                  end

                  unless faxMessage.scheduledStartTime.nil?
                    @xml.ScheduledStartTime(faxMessage.scheduledStartTime)
                  end

                  unless faxMessage.blocklists.nil?
                    @xml.Blocklists(faxMessage.blocklists)
                  end

                  unless faxMessage.retries.nil?
                    @xml.Retries(faxMessage.retries)
                  end

                  unless faxMessage.busyRetries.nil?
                    @xml.BusyRetries(faxMessage.busyRetries)
                  end

                  unless faxMessage.headerFormat.nil?
                    @xml.HeaderFormat(faxMessage.headerFormat)
                  end

                }
              end
            }

            unless sendFaxRequest.broadcastRef.nil?
              @xml.BroadcastRef(sendFaxRequest.broadcastRef)
            end

            unless sendFaxRequest.sendRef.nil?
              @xml.SendRef(sendFaxRequest.sendRef)
            end

            unless sendFaxRequest.sendFrom.nil?
              @xml.SendFrom(sendFaxRequest.sendFrom)
            end

            unless sendFaxRequest.resolution.nil?
              @xml.Resolution(sendFaxRequest.resolution)
            end

            unless sendFaxRequest.scheduledStartTime.nil?
              @xml.ScheduledStartTime(sendFaxRequest.scheduledStartTime)
            end

            unless sendFaxRequest.blocklists.nil?
              @xml.Blocklists(sendFaxRequest.blocklists)
            end

            unless sendFaxRequest.retries.nil?
              @xml.Retries(sendFaxRequest.retries)
            end

            unless sendFaxRequest.busyRetries.nil?
              @xml.BusyRetries(sendFaxRequest.busyRetries)
            end

            unless sendFaxRequest.headerFormat.nil?
              @xml.HeaderFormat(sendFaxRequest.headerFormat)
            end

          }
        }
      }
    end
  end

  def sendFax (sendFaxRequest)
    @response = @client.call(:send_fax, xml: SendFaxRequestEnvelope.new.to_s(sendFaxRequest, @wssetoken))
    #TODO return MonopondSendFaxResponse.new()
  end

  def faxStatus (faxStatusRequest)

  end

  def stopFax (stopFaxRequest)

  end

  def pauseFax (pauseFaxRequest)

  end

  def resumeFax (resumeFaxRequest)

  end
end

class MPENV
  PRODUCTION = 'https://api.monopond.com/fax/soap/v2/?wsdl'
  TEST = 'https://test.api.monopond.com/fax/soap/v2/?wsdl'
  LOCAL = 'http://localhost:8000/fax/soap/v2?wsdl'
end

class WSSEToken
  attr_accessor :username, :password
  def initialize (username, password)
    @username = username
    @password = password
  end
end

class MonopondDocument
  attr_accessor :fileName, :fileData, :order
  def initialize (fileName, fileData)
    @fileName = fileName
    @fileData = fileData
  end
end

class MonopondFaxMessage
  attr_accessor :messageRef, :sendTo, :sendFrom, :documents, :resolution,
                :scheduledStartTime, :blocklists, :retries, :busyRetries, :headerFormat
  def initialize (messageRef, sendTo)
    @messageRef = messageRef
    @sendTo = sendTo
  end
end

class MonopondFaxDetailsResponse
  attr_accessor :sendFrom, :resolution, :retries, :busyRetries, :headerFormat
  def initialize (response)
    @sendFrom = response.sendFrom
    @resolution = response.resolution
    @retries = response.retries
    @busyRetries = response.busyRetries
    @headerFormat = response.headerFormat
  end
end

class MonopondFaxResultsResponse
  attr_accessor :attempt, :result, :error, :cost, :pages,
                :scheduledStartTime, :dateCallStarted, :dateCallEnded
  def initialize (response)
    @attempt = response.attempt
    @result = response.result
    @error = response.error
    @cost = response.cost
    @pages = response.pages
    @scheduledStartTime = response.scheduledStartTime
    @dateCallStarted = response.dateCallStarted
    @dateCallEnded = response.dateCallEnded
  end
end

class MonopondFaxErrorResponse
  attr_accessor :code, :name
  def initialize (response)
    @code = response.code
    @name = response.name
  end
end

class MonopondFaxMessageResponse
  attr_accessor :status, :sendTo, :broadcastRef, :sendRef,
                :messageRef, :faxDetails, :faxResults
  def initialize (response)
    @status = response.status
    @sendTo = response.sendTo
    @broadcastRef = response.broadcastRef
    @sendRef = response.sendRef
    @messageRef = response.messageRef

    unless response.faxDetails.nil?
      @faxDetails = MonopondFaxDetailsResponse.new(response.faxDetails)
    end

    unless response.faxResults.nil?
      @faxResults = []
      for faxResult in response.faxResults
        faxResult << MonopondFaxResultsResponse.new(faxResult)
      end
    end
  end
end

class MonopondSendFaxRequest
  attr_accessor :broadcastRef, :sendRef, :faxMessages, :sendFrom, :documents,
                :resolution, :scheduledStartTime, :blocklists, :retries,
                :busyRetries, :headerFormat
  def initialize (faxMessages, documents)
    @faxMessages = faxMessages
    @documents = documents
  end
end

class MonopondSendFaxResponse
  attr_accessor :faxMessages
  def initialize (response)
    @faxMessages = []
    for faxMessage in response[:fax_messages]
      faxMessages << MonopondFaxMessageResponse.new(faxMessage)
    end
  end
end

class MonopondFaxStatusRequest

end

class MonopondFaxStatusResponse

end

class MonopondStopFaxRequest

end

class MonopondStopFaxResponse

end

class MonopondPauseFaxRequest

end

class MonopondPauseFaxResponse

end

class MonopondResumeFaxRequest

end

class MonopondResumeFaxResponse

end