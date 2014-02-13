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
        namespace:'https://api.monopond.com/fax/soap/v2.1', namespace_identifier: :v2,
        pretty_print_xml: true)

  end

  class SendFaxRequestEnvelope
    def to_s(sendFaxRequest, wsse)
      @xml = Builder::XmlMarkup.new
      @xml.tag!("soapenv:Envelope",
        "xmlns:soapenv" => "http://schemas.xmlsoap.org/soap/envelope/",
        "xmlns:wsse" => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd",
        "xmlns:v2" => "https://api.monopond.com/fax/soap/v2.1"
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
          @xml.tag!("v2:SendFaxRequest"){ |request|
            
            @xml.FaxMessages {
              for faxMessage in sendFaxRequest.faxMessages
                @xml.FaxMessage{ |fax|
                  fax.MessageRef(faxMessage.messageRef)

                  fax.SendTo(faxMessage.sendTo)

                  unless faxMessage.documents.nil?
                    @xml.Documents {
                      for document in faxMessage.documents
                        @xml.Document{ |doc|
                          MonopondRequestBuilder.new.populateDocument(document, doc);

                          unless document.docMergeData.nil?
                            @xml.DocMergeData {
                              for mergeField in document.docMergeData
                                @xml.MergeField { |mf|
                                  MonopondRequestBuilder.new.populateDocMergeDataMergeField(mergeField, mf);
                                }
                              end
                            }
                          end

                          unless document.stampMergeData.nil?
                            @xml.StampMergeData {
                              for mergeField in document.stampMergeData
                                @xml.MergeField { |mf|
                                  MonopondRequestBuilder.new.populateStampMergeDataMergeField(mergeField, mf);
                                }
                              end
                            }
                          end
                        }
                      end
                    }
                  end

                  MonopondRequestBuilder.new.populateSendFaxRequestAdditionalParams(faxMessage, fax)
                }
              end
            }

            unless sendFaxRequest.broadcastRef.nil?
              @xml.BroadcastRef(sendFaxRequest.broadcastRef)
            end

            unless sendFaxRequest.sendRef.nil?
              @xml.SendRef(sendFaxRequest.sendRef)
            end

            MonopondRequestBuilder.new.populateSendFaxRequestAdditionalParams(sendFaxRequest, request)

            unless sendFaxRequest.documents.nil?
               @xml.Documents {
                for document in sendFaxRequest.documents
                  @xml.Document{ |doc|
                    MonopondRequestBuilder.new.populateDocument(document, doc);

                    unless document.docMergeData.nil?
                      @xml.DocMergeData {
                        for mergeField in document.docMergeData
                          @xml.MergeField { |mf|
                            MonopondRequestBuilder.new.populateDocMergeDataMergeField(mergeField, mf);
                          }
                        end
                      }
                    end

                    unless document.stampMergeData.nil?
                      @xml.StampMergeData {
                        for mergeField in document.stampMergeData
                          @xml.MergeField { |mf|
                            MonopondRequestBuilder.new.populateStampMergeDataMergeField(mergeField, mf);
                          }
                        end
                      }
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

  class FaxDocumentPreviewRequestEnvelope
    def to_s(faxDocumentPreviewRequest, wsse)
      @xml = Builder::XmlMarkup.new
      @xml.tag!("soapenv:Envelope",
        "xmlns:soapenv" => "http://schemas.xmlsoap.org/soap/envelope/",
        "xmlns:wsse" => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd",
        "xmlns:v2" => "https://api.monopond.com/fax/soap/v2.1"
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
          @xml.tag!("v2:FaxDocumentPreviewRequest"){
            unless faxDocumentPreviewRequest.documentRef.nil?
              @xml.DocumentRef(faxDocumentPreviewRequest.documentRef)
            end

            unless faxDocumentPreviewRequest.resolution.nil?
              @xml.Resolution(faxDocumentPreviewRequest.resolution)
            end

            unless faxDocumentPreviewRequest.ditheringTechnique.nil?
              @xml.DitheringTechnique(faxDocumentPreviewRequest.ditheringTechnique)
            end

            unless faxDocumentPreviewRequest.docMergeData.nil?
              @xml.DocMergeData {
                for mergeField in faxDocumentPreviewRequest.docMergeData
                  @xml.MergeField { |mf|
                    MonopondRequestBuilder.new.populateDocMergeDataMergeField(mergeField, mf);
                  }
                end
              }
            end

            unless faxDocumentPreviewRequest.stampMergeData.nil?
              @xml.StampMergeData {
                for mergeField in faxDocumentPreviewRequest.stampMergeData
                  @xml.MergeField { |mf|
                    MonopondRequestBuilder.new.populateStampMergeDataMergeField(mergeField, mf);
                  }
                end
              }
            end
          }
        }
      }
    end
  end

  class MonopondRequestBuilder
    def populateSendFaxRequestAdditionalParams(source, dest)
      unless source.sendFrom.nil?
        dest.SendFrom(source.sendFrom)
      end

      unless source.resolution.nil?
        dest.Resolution(source.resolution)
      end

      unless source.scheduledStartTime.nil?
        dest.ScheduledStartTime(source.scheduledStartTime)
      end

      unless source.blocklists.nil?
        dest.Blocklists(source.blocklists)
      end

      unless source.retries.nil?
        dest.Retries(source.retries)
      end

      unless source.busyRetries.nil?
        dest.BusyRetries(source.busyRetries)
      end

      unless source.headerFormat.nil?
        dest.HeaderFormat(source.headerFormat)
      end

      unless source.mustBeSentBeforeDate.nil?
        dest.MustBeSentBeforeDate(source.mustBeSentBeforeDate)
      end

      unless source.maxFaxPages.nil?
        dest.MaxFaxPages(source.maxFaxPages)
      end

      unless source.cLI.nil?
        dest.CLI(source.cLI)
      end
    end

    def populateDocument (document, doc)
      unless document.documentRef.nil?
        doc.DocumentRef(document.documentRef);
      end
  
      unless document.fileName.nil?
        doc.FileName(document.fileName);
      end
    
      unless document.fileData.nil?
        doc.FileData(document.fileData);
      end
    
      unless document.order.nil?
        doc.Order(document.order);
      end
     
      unless document.ditheringTechnique.nil?
        doc.DitheringTechnique(document.ditheringTechnique);
      end
    end
    
    def populateDocMergeDataMergeField(mergeField, mf)
      mf.Key(mergeField.Key);
      mf.Value(mergeField.Value);
    end

    def populateStampMergeDataMergeField(mergeField, mf)
      unless mergeField.key.nil?
        mf.Key(:xCoord => mergeField.key.xCoord, :yCoord => mergeField.key.yCoord);
      end

      unless mergeField.textValue.nil?
        mf.TextValue(mergeField.textValue.textValue, :fontName => mergeField.textValue.fontName, :fontSize => mergeField.textValue.fontSize);
      end

      unless mergeField.imageValue.nil?
        mf.ImageValue(:width => mergeField.imageValue.width, :height => mergeField.imageValue.height) { |iv|
          iv.FileName(mergeField.imageValue.fileName)

          iv.FileData(mergeField.imageValue.fileData)
        };
      end
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
      @message["SendRef"] = faxStatusRequest.sendRef
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
      @message["SendRef"] = stopFaxRequest.sendRef
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
      @message["SendRef"] = pauseFaxRequest.sendRef
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
      @message["SendRef"] = resumeFaxRequest.sendRef
    end

    @response = @client.call(:resume_fax, message:@message)
  end

  def deleteFaxDocument (deleteFaxDocumentRequest)
    @message = {}

    unless deleteFaxDocumentRequest.documentRef.nil?
      @message["DocumentRef"] = deleteFaxDocumentRequest.documentRef
    end

    @response = @client.call(:delete_fax_document, message:@message)
  end

  def faxDocumentPreview (faxDocumentPreviewRequest)
    @response = @client.call(:fax_document_preview, xml: FaxDocumentPreviewRequestEnvelope.new.to_s(faxDocumentPreviewRequest, @wssetoken))
  end
end

class MPENV
  PRODUCTION = 'https://api.monopond.com/fax/soap/v2/?wsdl'
  TEST = 'https://test.api.monopond.com/fax/soap/v2/?wsdl'
  LOCAL = 'http://localhost:8000/fax/soap/v2?wsdl'
  LOCAL2 = 'http://localhost:8000/fax/soap/v2.1?wsdl'
end

class WSSEToken
  attr_accessor :username, :password
  def initialize (username, password)
    @username = username
    @password = password
  end
end

class MonopondDocument
  attr_accessor :documentRef, :fileName, :fileData, :order, :ditheringTechnique, :docMergeData, :stampMergeData
  def initialize (fileName, fileData)
    @fileName = fileName
    @fileData = fileData
  end
end

class MonopondFaxMessage
  attr_accessor :messageRef, :sendTo, :sendFrom, :documents, :resolution,
                :scheduledStartTime, :blocklists, :retries, :busyRetries, :headerFormat,
		:mustBeSentBeforeDate, :maxFaxPages, :cLI
  def initialize (messageRef, sendTo)
    @messageRef = messageRef
    @sendTo = sendTo
  end
end

class MonopondDocMergeFieldKey
  attr_accessor :Key, :Value
  def initialize (key, value)
    @Key = key
    @Value = value
  end
end

class MonopondStampMergeField
  attr_accessor :key, :textValue, :imageValue
end

class MonopondStampMergeFieldKey
  attr_accessor :xCoord, :yCoord
  def initialize (xCoord, yCoord)
    @xCoord = xCoord
    @yCoord = yCoord
  end
end

class MonopondStampMergeFieldTextValue
  attr_accessor :textValue, :fontName, :fontSize
  def initialize(textValue, fontName, fontSize)
    @textValue = textValue
    @fontName = fontName
    @fontSize = fontSize
  end
end

class MonopondStampMergeFieldImageValue
  attr_accessor :fileName, :fileData, :width, :height
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
                :busyRetries, :headerFormat, :mustBeSentBeforeDate, :maxFaxPages, :cLI
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
  attr_accessor :broadcastRef, :messageRef, :sendRef
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
  attr_accessor :broadcastRef, :messageRef, :sendRef
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
  attr_accessor :broadcastRef, :messageRef, :sendRef
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

class MonopondDeleteFaxDocumentRequest
  attr_accessor :documentRef
end

class MonopondDeleteFaxDocumentResponse
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

class MonopondFaxDocumentPreviewRequest
  attr_accessor :documentRef, :resolution, :ditheringTechnique, :docMergeData, :stampMergeData
  def initialize (documentRef)
    @documentRef = documentRef
  end
end

class MonopondFaxDocumentPreviewResponse
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
