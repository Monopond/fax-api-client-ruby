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

            unless sendFaxRequest.documents.nil?
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
            end

          }
        }
      }
    end
  end

  def sendFax (sendFaxRequest)
    @response = @client.call(:send_fax, xml: SendFaxRequestEnvelope.new.to_s(sendFaxRequest, @wssetoken))
    return MonopondSendFaxResponse.new(@response.body[:send_fax_response])
  end

  def faxStatus (faxStatusRequest)
    @message = {}

    unless faxStatusRequest.broadcastRef.nil?
      @message["BroadcastRef"] = faxStatusRequest.broadcastRef
    end

    unless faxStatusRequest.messageRef.nil?
      @message["MessageRef"] = faxStatusRequest.messageRef
    end

    unless faxStatusRequest.sendRef.nil?
      @message["sendRef"] = faxStatusRequest.sendRef
    end

    unless faxStatusRequest.verbosity.nil?
      @message["Verbosity"] = faxStatusRequest.verbosity
    end

    @response = @client.call(:fax_status, message:@message)
    return MonopondFaxStatusResponse.new(@response.body[:fax_status_response])
  end

  def stopFax (stopFaxRequest)
    @message = {}

    unless stopFaxRequest.broadcastRef.nil?
      @message["BroadcastRef"] = stopFaxRequest.broadcastRef
    end

    unless stopFaxRequest.messageRef.nil?
      @message["MessageRef"] = stopFaxRequest.messageRef
    end

    unless stopFaxRequest.sendRef.nil?
      @message["sendRef"] = stopFaxRequest.sendRef
    end

    unless stopFaxRequest.verbosity.nil?
      @message["Verbosity"] = stopFaxRequest.verbosity
    end

    @response = @client.call(:stop_fax, message:@message)
  end

  def pauseFax (pauseFaxRequest)
    @message = {}

    unless pauseFaxRequest.broadcastRef.nil?
      @message["BroadcastRef"] = pauseFaxRequest.broadcastRef
    end

    unless pauseFaxRequest.messageRef.nil?
      @message["MessageRef"] = pauseFaxRequest.messageRef
    end

    unless pauseFaxRequest.sendRef.nil?
      @message["sendRef"] = pauseFaxRequest.sendRef
    end

    unless pauseFaxRequest.verbosity.nil?
      @message["Verbosity"] = pauseFaxRequest.verbosity
    end

    @response = @client.call(:pause_fax, message:@message)
  end

  def resumeFax (resumeFaxRequest)
    @message = {}

    unless resumeFaxRequest.broadcastRef.nil?
      @message["BroadcastRef"] = resumeFaxRequest.broadcastRef
    end

    unless resumeFaxRequest.messageRef.nil?
      @message["MessageRef"] = resumeFaxRequest.messageRef
    end

    unless resumeFaxRequest.sendRef.nil?
      @message["sendRef"] = resumeFaxRequest.sendRef
    end

    unless resumeFaxRequest.verbosity.nil?
      @message["Verbosity"] = resumeFaxRequest.verbosity
    end

    @response = @client.call(:resume_fax, message:@message)
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
    @sendFrom = response[:@send_from]
    @resolution = response[:@resolution]
    @retries = response[:@retries]
    @busyRetries = response[:@busy_retries]
    @headerFormat = response[:@header_format]
  end
end

class MonopondFaxResultsResponse
  attr_accessor :attempt, :result, :error, :cost, :pages,
                :scheduledStartTime, :dateCallStarted, :dateCallEnded
  def initialize (response)
    @attempt = response[:@attempt]
    @result = response[:@result]
    @error = MonopondFaxErrorResponse.new(response[:@error])
    @cost = response[:@cost]
    @pages = response[:@pages]
    @scheduledStartTime = response[:@scheduled_start_time]
    @dateCallStarted = response[:@date_call_started]
    @dateCallEnded = response[:@date_call_ended]
  end
end

class MonopondFaxErrorResponse
  attr_accessor :code, :name
  def initialize (response)
    @code = response[:@code]
    @name = response[:@name]
  end
end

class MonopondFaxMessageResponse
  attr_accessor :status, :sendTo, :broadcastRef, :sendRef,
                :messageRef, :faxDetails, :faxResults
  def initialize (response)
    @status = response[:@status]
    @sendTo = response[:@send_to]
    @broadcastRef = response[:@broadcast_ref]
    @sendRef = response[:@send_ref]
    @messageRef = response[:@message_ref]

    unless response[:@fax_details].nil?
      @faxDetails = MonopondFaxDetailsResponse.new(response[:@fax_details])
    end

    unless response[:@fax_results].nil?
      @faxResults = []
      for faxResult in response[:@fax_results]
        faxResult << MonopondFaxResultsResponse.new(faxResult)
      end
    end
  end
end

class MonopondFaxStatusTotalsResponse
  attr_accessor :pending, :processing, :queued, :starting, :sending,
                :pausing, :paused, :resuming, :stopping, :finalizing, :done
  def initialize (response)
    unless response[:@pending].nil?
      @pending = response[:@pending]
    end

    unless response[:@processing].nil?
      @processing = response[:@processing]
    end

    unless response[:@queued].nil?
      @queued = response[:@queued]
    end

    unless response[:@starting].nil?
      @starting = response[:@starting]
    end

    unless response[:@sending].nil?
      @sending = response[:@sending]
    end

    unless response[:@pausing].nil?
      @pausing = response[:@pausing]
    end

    unless response[:@paused].nil?
      @paused = response[:@paused]
    end

    unless response[:@resuming].nil?
      @resuming = response[:@resuming]
    end

    unless response[:@stopping].nil?
      @stopping = response[:@stopping]
    end

    unless response[:@finalizing].nil?
      @finalizing = response[:@finalizing]
    end

    unless response[:@done].nil?
      @done = response[:@done]
    end
  end
end

class MonopondFaxResultTotalsResponse
  attr_accessor :success, :blocked, :failed, :totalAttempts,
                :totalFaxDuration, :totalPages
  def initialize (response)
    unless response[:@success].nil?
      @success = response[:@success]
    end

    unless response[:@blocked].nil?
      @blocked = response[:@blocked]
    end

    unless response[:@failed].nil?
      @failed = response[:@failed]
    end

    unless response[:@total_attempts].nil?
      @totalAttempts = response[:@total_attempts]
    end

    unless response[:@total_fax_duration].nil?
      @totalFaxDuration = response[:@total_fax_duration]
    end

    unless response[:@total_pages].nil?
      @totalPages = response[:@total_pages]
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
    @faxes = (response[:fax_messages][:fax_message])
    if @faxes.class == Array
      for faxMessage in @faxes
        @faxMessages << MonopondFaxMessageResponse.new(faxMessage)
      end
    else
      @faxMessages << MonopondFaxMessageResponse.new(@faxes)
    end
  end
end

class MonopondFaxStatusRequest
  attr_accessor :broadcastRef, :messageRef, :sendRef, :verbosity
end

class MonopondFaxStatusResponse
  attr_accessor :faxStatusTotals, :faxResultsTotals, :faxMessages
  def initialize (response)
    @faxStatusTotals = MonopondFaxStatusTotalsResponse.new(response[:fax_status_totals])
    @faxResultsTotals = MonopondFaxResultTotalsResponse.new(response[:fax_results_totals])
    @faxMessages = []
    unless response[:fax_messages].nil?
      for faxMessage in response[:fax_messages][:fax_message]
        @faxMessages << MonopondFaxMessageResponse.new(faxMessage)
      end
    end
  end
end

class MonopondStopFaxRequest
  attr_accessor :broadcastRef, :messageRef, :sendRef, :verbosity
end

class MonopondStopFaxResponse
  attr_accessor :faxMessages
  def initialize (response)
    @faxMessages = []
    unless response[:fax_messages].nil?
      for faxMessage in response[:fax_messages][:fax_message]
        @faxMessages << MonopondFaxMessageResponse.new(faxMessage)
      end
    end
  end
end

class MonopondPauseFaxRequest
  attr_accessor :broadcastRef, :messageRef, :sendRef, :verbosity
end

class MonopondPauseFaxResponse
  attr_accessor :faxMessages
  def initialize (response)
    @faxMessages = []
    unless response[:fax_messages].nil?
      for faxMessage in response[:fax_messages][:fax_message]
        @faxMessages << MonopondFaxMessageResponse.new(faxMessage)
      end
    end
  end
end

class MonopondResumeFaxRequest
  attr_accessor :broadcastRef, :messageRef, :sendRef, :verbosity
end

class MonopondResumeFaxResponse
  attr_accessor:faxMessages
  def initialize (response)
    @faxMessages = []
    unless response[:fax_messages].nil?
      for faxMessage in response[:fax_messages][:fax_message]
        @faxMessages << MonopondFaxMessageResponse.new(faxMessage)
      end
    end
  end
end
