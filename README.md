#Overview

* This is a SOAP Web Service client for Monopond Web Services built on top of Ruby.
* Requires <a href="http://savonrb.com/">Savon</a>, <a href="http://builder.rubyforge.org/">Builder</a> and <a href="http://rubygems.org/">Ruby Gems</a> to be installed.
* Provides concrete classes that you can use to map values to requests and read responses.

#Logging

* Raw xml requests/response are automatically printed out.


#Basic Usage

* Run `bundle` on your bash or command-line to download dependencies.

*MonopondSOAPClientV2*
 - the client object that hold the methods to send requests.
Request methods: (sendFax, faxStatus, pauseFax, resumeFax, stopFax, deleteFaxDocument, faxDocumentPreview)

#Building A Request

To use Monopond SOAP Ruby Client, start by including the MonopondSOAPClient.rb (line 1) then creating an instance of the client by supplying your credentials (line 4). Your username and password should be enclosed in quotation marks.
Monopond SOAP Ruby Client uses the following gems: savon and builder. Please check the Gemfile is included.

```ruby
require_relative ‘monopondSOAPClient’
     
// TODO: Enter your own credentials here
@wsseToken = WSSEToken.new('username', 'password')
@client = MonopondSOAPClientV2.new(@wsseToken, MPENV::LOCAL)
     
// TODO: Set up your request here
```

#SendFax
###Description
This is the core function in the API allowing you to send faxes on the platform. 

Your specific faxing requirements will dictate which send request type below should be used. The two common use cases would be the sending of a single fax document to one destination and the sending of a single fax document to multiple destinations.

###Request
**MonopondSendFaxRequest Parameters:**

**Name**|**Required**|**Type**|**Description**|**Default**
-----|-----|-----|-----|-----
**BroadcastRef**||String|Allows the user to tag all faxes in this request with a user-defined broadcastreference. These faxes can then be retrieved at a later point based on this reference.|
**SendRef**||String|Similar to the BroadcastRef, this allows the user to tag all faxes in this request with a send reference. The SendRef is used to represent all faxes in this request only, so naturally it must be unique.|
**FaxMessages**|**X**| Array of FaxMessage |FaxMessages describe each individual fax message and its destination. See below for details.|
**SendFrom**||Alphanumeric String|A customisable string used to identify the sender of the fax. Also known as the Transmitting Subscriber Identification (TSID). The maximum string length is 32 characters|Fax
**Documents**|**X**|Array of apiFaxDocument|Each FaxDocument object describes a fax document to be sent. Multiple documents can be defined here which will be concatenated and sent in the same message. See below for details.|
**Resolution**||Resolution|Resolution setting of the fax document. Refer to the resolution table below for possible resolution values.|normal
**ScheduledStartTime**||DateTime|The date and time the transmission of the fax will start.|Current time (immediate sending)
**Blocklists**||Blocklists|The blocklists that will be checked and filtered against before sending the message. See below for details.WARNING: This feature is inactive and non-functional in this (2.1) version of the Fax API.|
**Retries**||Unsigned Integer|The number of times to retry sending the fax if it fails. Each account has a maximum number of retries that can be changed by consultation with your account manager.|Account Default
**BusyRetries**||Unsigned Integer|Certain fax errors such as “NO_ANSWER” or “BUSY” are not included in the above retries limit and can be set separately. Each account has a maximum number of busy retries that can be changed by consultation with your account manager.|Account default
**HeaderFormat**||String|Allows the header format that appears at the top of the transmitted fax to be changed. See below for an explanation of how to format this field.| From: X, To: X
**MustBeSentBeforeDate** | | DateTime |  Specifies a time the fax must be delivered by. Once the specified time is reached the fax will be cancelled across the system. | 
**MaxFaxPages** | | Unsigned Integer |  Sets a limit on the amount of pages allowed in a single fax transmission. Especially useful if the user is blindly submitting their customer's documents to the platform. | 20

***MonopondFaxMessage Parameters:***
This represents a single fax message being sent to a destination.

**Name** | **Required** | **Type** | **Description** | **Default** 
-----|-----|-----|-----|-----
**MessageRef** | **X** | String | A unique user-provided identifier that is used to identify the fax message. This can be used at a later point to retrieve the results of the fax message. |
**SendTo** | **X** | String | The phone number the fax message will be sent to. |
**SendFrom** | | Alphanumeric String | A customisable string used to identify the sender of the fax. Also known as the Transmitting Subscriber Identification (TSID). The maximum string length is 32 characters | Empty
**Documents** | **X** | Array of apiFaxDocument | Each FaxDocument object describes a fax document to be sent. Multiple documents can be defined here which will be concatenated and sent in the same message. See below for details. | 
**Resolution** | | Resolution|Resolution setting of the fax document. Refer to the resolution table below for possible resolution values.| normal
**ScheduledStartTime** | | DateTime | The date and time the transmission of the fax will start. | Start now
**Blocklists** | | Blocklists | The blocklists that will be checked and filtered against before sending the message. See below for details. WARNING: This feature is inactive and non-functional in this (2.1) version of the Fax API. |
**Retries** | | Unsigned Integer | The number of times to retry sending the fax if it fails. Each account has a maximum number of retries that can be changed by consultation with your account manager. | Account Default
**BusyRetries** | | Unsigned Integer | Certain fax errors such as “NO_ANSWER” or “BUSY” are not included in the above retries limit and can be set separately. Please consult with your account manager in regards to maximum value.|account default
**HeaderFormat** | | String | Allows the header format that appears at the top of the transmitted fax to be changed. See below for an explanation of how to format this field. | From： X, To: X
**MustBeSentBeforeDate** | | DateTime |  Specifies a time the fax must be delivered by. Once the specified time is reached the fax will be cancelled across the system. | 
**MaxFaxPages** | | Unsigned Integer |  Sets a limit on the amount of pages allowed in a single fax transmission. Especially useful if the user is blindly submitting their customer's documents to the platform. | 20
**CLI**| | String| Allows a customer called ID. Note: Must be enabled on the account before it can be used.

***MonopondFaxDocument Parameters:***
Represents a fax document to be sent through the system. Supported file types are: PDF, TIFF, PNG, JPG, GIF, TXT, PS, RTF, DOC, DOCX, XLS, XLSX, PPT, PPTX.

**Name**|**Required**|**Type**|**Description**|**Default**
-----|-----|-----|-----|-----
**FileName**|**X**|String|The document filename including extension. This is important as it is used to help identify the document MIME type.|
**FileData**|**X**|Base64|The document encoded in Base64 format.|
**Order** | | Integer|If multiple documents are defined on a message this value will determine the order in which they will be transmitted.|0|
**DocMergeData**||MonpondDocMergeFieldKey|An Array of MergeFields|
**StampMergeData**||MonopondStampMergeFieldKey|An Array of MergeFields|

***Resolution Levels:***

| **Value** | **Description** |
| --- | --- |
| **normal** | Normal standard resolution (98 scan lines per inch) |
| **fine** | Fine resolution (196 scan lines per inch) |

***Header Format:***
Determines the format of the header line that is printed on the top of the transmitted fax message.
This is set to **rom %from%, To %to%|%a %b %d %H:%M %Y”**y default which produces the following:

From TSID, To 61022221234 Mon Aug 28 15:32 2012 1 of 1

**Value** | **Description**
--- | ---
**%from%**|The value of the **SendFrom** field in the message.
**%to%**|The value of the **SendTo** field in the message.
**%a**|Weekday name (abbreviated)
**%A**|Weekday name
**%b**|Month name (abbreviated)
**%B**|Month name
**%d**|Day of the month as a decimal (01 – 31)
**%m**|Month as a decimal (01 – 12)
**%y**|Year as a decimal (abbreviated)
**%Y**|Year as a decimal
**%H**|Hour as a decimal using a 24-hour clock (00 – 23)
**%I**|Hour as a decimal using a 12-hour clock (01 – 12)
**%M**|Minute as a decimal (00 – 59)
**%S**|Second as a decimal (00 – 59)
**%p**|AM or PM
**%j**|Day of the year as a decimal (001 – 366)
**%U**|Week of the year as a decimal (Monday as first day of the week) (00 – 53)
**%W**|Day of the year as a decimal (001 – 366)
**%w**|Day of the week as a decimal (0 – 6) (Sunday being 0)
**%%**|A literal % character

TODO: The default value is set to: “From %from%, To %to%|%a %b %d %H:%M %Y”

<a name="docMergeDataParameters"></a> 
**MonpondDocMergeFieldKey (Merge Field) Parameters:**

|**Name** | **Required** | **Type** | **Description** |
|-----|-----|-----|-----|
|**Key** | | *String* | A unique identifier used to determine which fields need replacing. |
|**Value** | | *String* | The value that replaces the key. |

<a name="stampMergeDataParameters"></a> 
**MonpondStampMergeFieldKey (Merge Field) Parameters:**

|**Name** | **Required** | **Type** | **Description** |
|-----|-----|-----|-----|
|**Key** |  | *MonopondStampMergeFieldKey* | Contains x and y coordinates where the ImageValue or TextValue should be placed. |
|**TextValue** |  | *MonopondStampMergeFieldTextValue* | The text value that replaces the key. |
|**ImageValue** |  | *MonopondStampMergeFieldImageValue* | The image value that replaces the key. |

 **MonopondStampMergeFieldKey Parameters:**

| **Name** | **Required** | **Type** | **Description** |
|----|-----|-----|-----|
| **xCoord** |  | *Int* | X coordinate. |
| **yCoord** |  | *Int* | Y coordinate. |

**MonopondStampMergeFieldTextValue Parameters:**

|**Name** | **Required** | **Type** | **Description** |
|-----|-----|-----|-----|
|**fontName** |  | *String* | Font name to be used. |
|**fontSize** |  | *Decimal* | Font size to be used. |

**MonopondStampMergeFieldImageValue Parameters:**

|**Name** | **Required** | **Type** | **Description** |
|-----|-----|-----|-----|
|**FileName** |  | *String* | The document filename including extension. This is important as it is used to help identify the document MIME type. |
|**FileData** |  | *Base64* | The document encoded in Base64 format. |
|**width** |  | *Int* | The new width of the image to be stamped. |
|**height** |  | *Int* | The new height of the image to be stamped. |

###Response
The response received from a `SendFaxRequest` matches the response you receive when calling the `FaxStatus` method call with a `send` verbosity level.

###SOAP Faults
This function will throw one of the following SOAP faults/exceptions if something went wrong:
**InvalidArgumentsException, NoMessagesFoundException, DocumentContentTypeNotFoundException, or InternalServerException.**
You can find more details on these faults [here](#section5).


###Sending a single fax:
To send a fax to a single destination a request similar to the following example can be used:

```ruby
// TODO: Setup Document
// 'filename', 'base64'
@document = MonopondDocument.new('test.txt','VGhpcyBpcyBhIGZheA==')
@document.order = 0

// TODO: Setup FaxMessage
// 'messageRef', 'sendTo'
@faxMessage = MonopondFaxMessage.new('msg-ref-1', '6011111111')
@faxMessage.sendFrom = 'Test Fax'
@faxMessage.resolution = 'normal'
@faxMessage.retries = 0
@faxMessage.busyRetries = 2

// TODO: Setup FaxSendRequest
@faxMessages = []
@faxMessages << @faxMessage
@documents = []
@documents << @document
@request = MonopondSendFaxRequest.new(@faxMessages, @documents)
@request.resolution = 'fine'
@request.broadcastRef = "broadcast-ref-1"

// Call sendFax method
@sendRespone = @client.sendFax(@request)
```

###Sending multiple faxes:
To send faxes to multiple destinations a request similar to the following example can be used. Please note the addition of another “FaxMessage”:
```ruby
// TODO: Setup Document
// 'filename', 'base64'
@document = MonopondDocument.new('test.txt','VGhpcyBpcyBhIGZheA==')
@document1 = MonopondDocument.new('test1.txt','VGhpcyBpcyBhIGZheA==')
@document2 = MonopondDocument.new('test2.txt','VGhpcyBpcyBhIGZheA==')

@document.order = 0;
@documents = []
@documents << @document
@documents << @document1
@documents << @document2

// TODO: Setup FaxMessage
// 'messageRef', 'sendTo'
@faxMessage = MonopondFaxMessage.new('msg-ref-1', '6011111111')
@faxMessage.sendFrom = 'Test Fax'
@faxMessage.resolution = 'normal'
@faxMessage.retries = 0
@faxMessage.documents = @documents
@faxMessage.busyRetries = 2

// TODO: Setup FaxSendRequest
@faxMessages = []
@faxMessages << @faxMessage
@request = MonopondSendFaxRequest.new(@faxMessages, [])
@request.resolution = 'fine'
@request.broadcastRef = "broadcast-ref-1"

// Call send fax method
@sendRespone = @client.sendFax(@request)
```

###Sending faxes to multiple destinations with the same document (broadcasting):
To send the same fax content to multiple destinations (broadcasting) a request similar to the example below can be used.

This method is recommended for broadcasting as it takes advantage of the multiple tiers in the send request. This eliminates the repeated parameters out of the individual fax message elements which are instead inherited from the parent send fax request. An example below shows “SendFrom” being used for both FaxMessages. While not shown in the example below further control can be achieved over individual fax elements to override the parameters set in the parent.

```ruby
// TODO: Setup Document
// 'filename', 'base64'
@document = MonopondDocument.new('test.txt','VGhpcyBpcyBhIGZheA==')
@document.order = 0;

// TODO: Setup FaxMessage
// 'messageRef', 'sendTo'
@faxMessage = MonopondFaxMessage.new('msg-ref-1', '6011111111')
@faxMessage.sendFrom = 'Test Fax'
@faxMessage.resolution = 'normal'
@faxMessage.retries = 0
@faxMessage.busyRetries = 2

@faxMessage1 = MonopondFaxMessage.new('msg-ref-1', '6011111112')
@faxMessage1.sendFrom = 'Test Fax'
@faxMessage1.resolution = 'normal'
@faxMessage1.retries = 0
@faxMessage1.busyRetries = 2

@faxMessage2 = MonopondFaxMessage.new('msg-ref-1', '6011111113')
@faxMessage2.sendFrom = 'Test Fax'
@faxMessage2.resolution = 'normal'
@faxMessage2.retries = 0
@faxMessage2.busyRetries = 2

// TODO: Setup FaxSendRequest
@faxMessages = []
@faxMessages << @faxMessage
@faxMessages << @faxMessage1
@faxMessages << @faxMessage2

@documents = []
@documents << @document

@request = MonopondSendFaxRequest.new(@faxMessages, @documents)
@request.resolution = 'fine'
@request.broadcastRef = "broadcast-ref-1"

// Call send fax method
@sendRespone = @client.sendFax(@request)
```

When sending multiple faxes in batch it is recommended to group them into requests of around 600 fax messages for optimal performance. If you are sending the same document to multiple destinations it is strongly advised to only attach the document once in the root of the send request rather than attaching a document for each destination.

###Sending Microsoft Documents With DocMergeData:
(This request only works in version 2.1(or higher) of the fax-api.)

This request is used to send a Microsoft document with replaceable variables or merge fields. The merge field follows the pattern ```<mf:key>```.  If your key is ```field1```, it should be typed as ```<mf:field1>``` in the document. Note that the key must be unique within the whole document. The screenshots below are examples of what the request does.

![before](https://github.com/Monopond/fax-api/raw/master/img/DocMergeData/before.png)

This is what the file looks like after the fields ```field1```,```field2``` and ```field3``` have been replaced with values ```lazy dog```, ```fat pig``` and ```fat pig```:

![stamp](https://github.com/Monopond/fax-api/raw/master/img/DocMergeData/after.png)

##### Sample Request
The example below shows ```field1``` will be replaced by the value of ```Test```.

```ruby
// TODO: Setup Merge Fields
// Identify 'mf:' keys to be replaced
@docMergeField1 = MonopondDocMergeFieldKey.new("field1", "Test");
@docMergeField2 = MonopondDocMergeFieldKey.new("field2", "fat pig");

@docMergeFields = [];
@docMergeFields << @docMergeField1
@docMergeFields << @docMergeField2

// TODO: Setup Document
// Identify documentRef
@document = MonopondDocument.new(nil, nil)
@document.docMergeData = @docMergeFields
@document.documentRef = 'doc-ref-sample-doc'

@documents = []
@documents << @document

// TODO: Setup FaxMessage
@faxMessage1 = MonopondFaxMessage.new('msg-ref-1', '6011111112')
@faxMessage1.sendFrom = 'Test Fax'
@faxMessage1.resolution = 'normal'
@faxMessage1.retries = 0
@faxMessage1.busyRetries = 2

@faxMessages = []
@faxMessages << @faxMessage1

// TODO: Setup FaxSendRequest
@request = MonopondSendFaxRequest.new(@faxMessages, @documents)
@request.resolution = 'fine'
@request.broadcastRef = "broadcast-ref-1"

// Call send fax method
@sendRespone = @client.sendFax(@request)
```

###Sending Tiff and PDF files with StampMergeData:
(This request only works in version 2.1(or higher) of the fax-api.)

This request allows a PDF or TIFF file to be stamped with an image or text, based on X-Y coordinates. The x and y coordinates (0,0) starts at the top left part of the document. The screenshots below are examples of what the request does.

Original tiff file:

![before](https://github.com/Monopond/fax-api/raw/master/img/StampMergeData/image_stamp/before.png)

Sample stamp image:

![stamp](https://github.com/Monopond/fax-api/raw/master/img/StampMergeData/image_stamp/stamp.png)

This is what the tiff file looks like after stamping it with the image above:

![after](https://github.com/Monopond/fax-api/raw/master/img/StampMergeData/image_stamp/after.png) 

The same tiff file, but this time, with a text stamp:

![after](https://github.com/Monopond/fax-api/raw/master/img/StampMergeData/text_stamp/after.png) 

##### Sample Request

The example below shows a PDF that will be stamped with the text “Hello” at xCoord=“1287” and yCoord=“421”, and an image at xCoord=“283” and yCoord=“120”

```ruby
// TODO: Setup Stamp Merge Field Key coordinates
@stampMergeFieldKey1 = MonopondStampMergeFieldKey.new(1287, 421);

// TODO: Setup Stamp Merge Field Text Value contents
@stampMergeFieldTextValue1 = MonopondStampMergeFieldTextValue.new("Hello", "Ubuntu-Bold", 14);

// TODO: Setup Stamp Merge Field Key coordinates
@stampMergeFieldKey1 = MonopondStampMergeFieldKey.new(283, 120);

// TODO: Setup Stamp Merge Field 
@stampMergeFieldImageValue1 = MonopondStampMergeFieldImageValue.new
@stampMergeFieldImageValue1.fileName = "stamp.png";
@stampMergeFieldImageValue1.fileData = "somebase64Data"
@stampMergeFieldImageValue1.width = 200
@stampMergeFieldImageValue1.height = 82

@docMergeFields = [];
@docMergeFields << @docMergeField1
@docMergeFields << @docMergeField2

// TODO: Setup Document
// Identify documentRef
@document = MonopondDocument.new(nil, nil)
@document.docMergeData = @docMergeFields
@document.documentRef = 'doc-ref-sample-doc'

@documents = []
@documents << @document

// TODO: Setup FaxMessage
@faxMessage1 = MonopondFaxMessage.new('msg-ref-1', '6011111112')
@faxMessage1.sendFrom = 'Test Fax'
@faxMessage1.resolution = 'normal'
@faxMessage1.retries = 0
@faxMessage1.busyRetries = 2

@faxMessages = []
@faxMessages << @faxMessage1

// TODO: Setup FaxSendRequest
@request = MonopondSendFaxRequest.new(@faxMessages, @documents)
@request.resolution = 'fine'
@request.broadcastRef = "broadcast-ref-1"

// Call send fax method
@sendRespone = @client.sendFax(@request)
```

##FaxStatus
###Description

This function provides you with a method of retrieving the status, details and results of fax messages sent. While this is a legitimate method of retrieving results we strongly advise that you take advantage of our callback service, which will push these fax results to you as they are completed.

When making a status request, you must provide at least a `BroadcastRef`, `SendRef` or `MessageRef`. The 
function will also accept a combination of these to further narrow the request query.
- Limiting by a `BroadcastRef` allows you to retrieve faxes contained in a group of send requests.
- Limiting by `SendRef` allows you to retrieve faxes contained in a single send request.
- Limiting by `MessageRef` allows you to retrieve a single fax message.

There are multiple levels of verbosity available in the request; these are explained in detail below.

###Request
**FaxStatusRequest Parameters:**

| **Name** | **Required** | **Type** | **Description** |
|--- | --- | --- | --- | ---|
|**BroadcastRef**|  | *String* | User-defined broadcast reference. |
|**SendRef**|  | *String* | User-defined send reference. |
|**MessageRef**|  | *String* | User-defined message reference. |
|**Verbosity**|  | *String* | Verbosity String The level of detail in the status response. Please see below for a list of possible values.| |

**Verbosity Levels:**	
  
| **Value** | **Description** |
| --- | --- |
| **brief** | Gives you an overall view of the messages. This simply shows very high-level statistics, consisting of counts of how many faxes are at each status (i.e. processing, queued,sending) and totals of the results of these faxes (success, failed, blocked). |
| **send** | send Includes the results from ***“brief”*** while also including an itemised list of each fax message in the request. |
| **details** | details Includes the results from ***“send”*** along with details of the properties used to send the fax messages. |
| **results** |Includes the results from ***“send”*** along with the sending results of the fax messages. |
| **all** | all Includes the results from both ***“details”*** and ***“results”*** along with some extra uncommon fields. |

###Response
The response received depends entirely on the verbosity level specified.

**FaxStatusResponse Parameters:**

| Name | Type | Verbosity | Description |
| --- | --- | --- | --- |
| **FaxStatusTotals** | *FaxStatusTotals* | *brief* | Counts of how many faxes are at each status. See below for more details. |
| **FaxResultsTotals** | *FaxResultsTotals* | *brief* | FaxResultsTotals FaxResultsTotals brief Totals of the end results of the faxes. See below for more details. |
| **FaxMessages** | *Array of FaxMessage* | *send* | send List of each fax in the query. See below for more details. |

**FaxStatusTotals Parameters:**

Contains the total count of how many faxes are at each status. 
To see more information on each fax status, view the FaxStatus table below.

| Name | Type | Verbosity | Description |
| --- | --- | --- | --- |
| **pending** | *Long* | *brief* | Fax is pending on the system and waiting to be processed.|
| **processing** | *Long* | *brief* | Fax is in the initial processing stages. |
| **queued** | *Long* | *brief* | Fax has finished processing and is queued, ready to send out at the send time. |
| **starting** | *Long* | *brief* | Fax is ready to be sent out. |
| **sending** | *Long* | *brief* | Fax has been spooled to our servers and is in the process of being sent out. |
| **finalizing** | *Long* | *brief* | Fax has finished sending and the results are being processed.|
| **done** | *Long* | *brief* | Fax has completed and no further actions will take place. The detailed results are available at this status. |

**FaxResultsTotals Parameters:**

Contains the total count of how many faxes ended in each result, as well as some additional totals. To view more information on each fax result, view the FaxResults table below.

| Name | Type | Verbosity | Description |
| --- | --- | --- | --- |
| **success** | *Long* | *brief* | Fax has successfully been delivered to its destination.|
| **blocked** | *Long* |  *brief* | Destination number was found in one of the block lists. |
| **failed** | *Long* | *brief* | Fax failed getting to its destination.|
| **totalAttempts** | *Long* | *brief* |Total attempts made in the reference context.|
| **totalFaxDuration** | *Long* | *brief* |totalFaxDuration Long brief Total time spent on the line in the reference context.|
| **totalPages** | *Long* | *brief* | Total pages sent in the reference context.|


**FaxMesssage Parameters:**

| Name | Type | Verbosity | Description |
| --- | --- | --- | --- |
| **messageRef** | *String* | *send* | |
| **sendRef** | *String* | *send* | |
| **broadcastRef** | *String* | *send* | |
| **sendTo** | *String* | *send* | |
| **status** |  | *send* | The current status of the fax message. See the FaxStatus table above for possible status values. |
| **FaxDetails** | *FaxDetails* | *details* | Contains the details and settings the fax was sent with. See below for more details. |
| **FaxResults** | *Array of FaxResult* | *results* | Contains the results of each attempt at sending the fax message and their connection details. See below for more details. |

**FaxDetails Parameters:**

| Name | Type | Verbosity |
| --- | --- | --- | --- |
| **sendFrom** | *Alphanumeric String* | *details* |
| **resolution** | *String* | *details* |
| **retries** | *Integer* | *details* |
| **busyRetries** | *Integer* | *details* |
| **headerFormat** | *String* | *details* |

**FaxResults Parameters:**

| Name | Type | Verbosity | Description |
| --- | --- | --- | --- |
| **attempt** | *Integer* | *results* | The attempt number of the FaxResult. |
| **result** | *String* | *results* | The result of the fax message. See the FaxResults table above for all possible results values. |
| **Error** | *FaxError* | *results* |  The fax error code if the fax was not successful. See below for all possible values. |
| **cost** | *BigDecimal* | *results* | The final cost of the fax message. | 
| **pages** | *Integer* | *results* | Total pages sent to the end fax machine. |
| **scheduledStartTime** | *DateTime* | *results* | The date and time the fax is scheduled to start. |
| **dateCallStarted** | *DateTime* | *results* | Date and time the fax started transmitting. |
| **dateCallEnded** | *DateTime* | *results* | Date and time the fax finished transmitting. |

**FaxError:**

| Value | Error Name |
| --- | --- |
| **DOCUMENT_EXCEEDS_PAGE_LIMIT** | Document exceeds page limit |
| **DOCUMENT_UNSUPPORTED** | Unsupported document type |
| **DOCUMENT_FAILED_CONVERSION** | Document failed conversion |
| **FUNDS_INSUFFICIENT** | Insufficient funds |
| **FUNDS_FAILED** | Failed to transfer funds |
| **BLOCK_ACCOUNT** | Number cannot be sent from this account |
| **BLOCK_GLOBAL** | Number found in the Global blocklist |
| **BLOCK_SMART** | Number found in the Smart blocklist |
| **BLOCK_DNCR** | Number found in the DNCR blocklist |
| **BLOCK_CUSTOM** | Number found in a user specified blocklist |
| **FAX_NEGOTIATION_FAILED** | Negotiation failed |
| **FAX_EARLY_HANGUP** | Early hang-up on call |
| **FAX_INCOMPATIBLE_MACHINE** | Incompatible fax machine |
| **FAX_BUSY** | Phone number busy |
| **FAX_NUMBER_UNOBTAINABLE** | Number unobtainable |
| **FAX_SENDING_FAILED** | Sending fax failed |
| **FAX_CANCELLED** | Cancelled |
| **FAX_NO_ANSWER** | No answer |
| **FAX_UNKNOWN** | Unknown fax error |

###SOAP Faults

This function will throw one of the following SOAP faults/exceptions if something went wrong:

**InvalidArgumentsException**, **NoMessagesFoundException**, or **InternalServerException**.
You can find more details on these faults in Section 5 of this document.You can find more details on these faults in the next section of this document.

###Sending a faxStatus Request with “brief” verbosity:
```ruby
// TODO: Setup FaxStatusRequest
@faxStatusRequest = MonopondFaxStatusRequest.new
@faxStatusRequest.messageRef = "Testing-message-1"

// Call fax status method
@faxStatus = @client.faxStatus(@faxStatusRequest)
```

###Status Request with “send” verbosity:
```ruby
// TODO: Setup FaxStatusRequest
@faxStatusRequest = MonopondFaxStatusRequest.new
@faxStatusRequest.broadcastRef = "Broadcast-test-1"
@faxStatusRequest.verbosity = "send"

// Call fax status method
@faxStatus = @client.faxStatus(@faxStatusRequest)
```

###Status Request with “details” verbosity:
```ruby
// TODO: Setup FaxStatusRequest
@faxStatusRequest = MonopondFaxStatusRequest.new
@faxStatusRequest.sendRef = "Send-Ref-1"
@faxStatusRequest.verbosity = "details"

// Call fax status method
@faxStatus = @client.faxStatus(@faxStatusRequest)
```

###Status Request with “results” verbosity:
```ruby
// TODO: Setup FaxStatusRequest
@faxStatusRequest = MonopondFaxStatusRequest.new
@faxStatusRequest.broadcastRef = "Broadcast-test-1"
@faxStatusRequest.sendRef = "Send-Ref-1"
@faxStatusRequest.verbosity = "results"

// Call fax status method
@faxStatus = @client.faxStatus(@faxStatusRequest)
```

##StopFax

###Description
Stops a fax message from sending. This fax message must either be paused, queued, starting or sending. Please note the fax cannot be stopped if the fax is currently in the process of being transmitted to the destination device.

When making a stop request you must provide at least a BroadcastRef, SendRef or MessageRef. The function will also accept a combination of these to further narrow down the request.

###Request
**MonopondStopFaxRequest Parameters:**

| Name | Required | Type | Description |
| --- | --- | --- | --- | --- |
| **BroadcastRef** | | *String* | User-defined broadcast reference. |
| **SendRef** |  | *String* | User-defined send reference. |
| **MessageRef** |  | *String* | User-defined message reference. |

###Response
The response received from a StopFaxRequest is the same response you would receive when calling the FaxStatus method call with the “send” verbosity level.

###SOAP Faults
This function will throw one of the following SOAP faults/exceptions if something went wrong:

**InvalidArgumentsException**, **NoMessagesFoundException**, or **InternalServerException**.
You can find more details on these faults in Section 5 of this document.You can find more details on these faults in the next section of this document.


###StopFax request with broadcast reference
```ruby
//TODO: Setup Stop Fax request
@request = MonopondStopFaxRequest.new
@request.broadcastRef = 'test-bc-1';
@response = @client.stopFax(@request)
```

###StopFax request with message reference
```ruby
//TODO: Setup Stop Fax request
@request = MonopondStopFaxRequest.new
@request.messageRef = 'test-mr-1';
@response = @client.stopFax(@request)
```

###StopFax request with send reference
```ruby
//TODO: Setup Stop Fax request
@request = MonopondStopFaxRequest.new
@request.sendRef = 'test-sr-1';
@response = @client.stopFax(@request)
```

##PauseFax

###Description
Pauses a fax message before it starts transmitting. This fax message must either be queued, starting or sending. Please note the fax cannot be paused if the message is currently being transmitted to the destination device.

When making a pause request, you must provide at least a BroadcastRef, SendRef or MessageRef. The function will also accept a combination of these to further narrow down the request. 

###Request
**MonopondPauseFaxRequest Parameters:**

| Name | Required | Type | Description |
| --- | --- | --- | --- | --- |
| **BroadcastRef** | | *String* | User-defined broadcast reference. |
| **SendRef** |  | *String* | User-defined send reference. |
| **MessageRef** |  | *String* | User-defined message reference. |

###Response
The response received from a PauseFaxRequest is the same response you would receive when calling the FaxStatus method call with the ***“send”*** verbosity level. 

###SOAP Faults
This function will throw one of the following SOAP faults/exceptions if something went wrong:
**InvalidArgumentsException**, **NoMessagesFoundException**, or **InternalServerException**.
You can find more details on these faults in Section 5 of this document.You can find more details on these faults in the next section of this document.

###PauseFax request with broadcast reference
```ruby
//TODO: Setup Pause Fax request
@request = MonopondPauseFaxRequest.new
@request.broadcastRef= "test-bcr-1"
@response = @client.pauseFax(@request)
```

###PauseFax request with message reference
```ruby
//TODO: Setup Pause Fax request
@request = MonopondPauseFaxRequest.new
@request.messageRef= "test-mr-1"
@response = @client.pauseFax(@request)
```

###PauseFax request with send reference
```ruby
//TODO: Setup Pause Fax request
@request = MonopondPauseFaxRequest.new
@request.sendRef= "test-sr-1"
@response = @client.pauseFax(@request)
```

##ResumeFax

###Description
When making a resume request, you must provide at least a BroadcastRef, SendRef or MessageRef. The function will also accept a combination of these to further narrow down the request. 

###Request
**MonopondResumeFaxRequest Parameters:**

| Name | Required | Type | Description |
| --- | --- | --- | --- | --- |
| **BroadcastRef** | | *String* | User-defined broadcast reference. |
| **SendRef** |  | *String* | User-defined send reference. |
| **MessageRef** |  | *String* | User-defined message reference. |

###Response
The response received from a ResumeFaxRequest is the same response you would receive when calling the FaxStatus method call with the “send” verbosity level. 

###SOAP Faults
This function will throw one of the following SOAP faults/exceptions if something went wrong:
**InvalidArgumentsException**, **NoMessagesFoundException**, or **InternalServerException**.
You can find more details on these faults in Section 5 of this document.You can find more details on these faults in the next section of this document.

###ResumeFax request with broadcast reference
```ruby
//TODO: Setup Resume Fax request
@request = MonopondResumeFaxRequest.new
@request.broadcastRef= "test-bcr-1"
@response = @client.resumeFax(@request)
```

###ResumeFax request with message reference
```ruby
//TODO: Setup Resume Fax request
@request = MonopondResumeFaxRequest.new
@request.messageRef= "test-mr-1"
@response = @client.resumeFax(@request)
```

###ResumeFax request with send reference
```ruby
//TODO: Setup Resume Fax request
@request = MonopondResumeFaxRequest.new
@request.sendRef= "test-sr-1"
@response = @client.resumeFax(@request)
```

##PreviewFaxDocument
###Description

This function provides you with a method to generate a preview of a saved document at different resolutions with various dithering settings. It returns a tiff data in base64 along with a page count.

###Request
**MonopondFaxDocumentPreviewRequest Parameters:**

| **Name** | **Required** | **Type** | **Description** | **Default** |
|--- | --- | --- | --- | ---|
|**Resolution**|  | *Resolution* |Resolution setting of the fax document. Refer to the resolution table below for possible resolution values.| normal |
|**DitheringTechnique**| | *FaxDitheringTechnique* | Applies a custom dithering method to the fax document before transmission. | |
|**DocMergeData** | | *Array of MonopondDocMergeFieldKey MergeFields* | Each mergefield has a key and a value. The system will look for the keys in a document and replace them with their corresponding value. ||
|**StampMergeData** | | *Array of MonopondStampMergeFieldKey MergeFields* | Each mergefield has a key a corressponding TextValue/ImageValue. The system will look for the keys in a document and replace them with their corresponding value. | | |

**MonopondDocMergeFieldKey (Mergefield) Parameters:**

|**Name** | **Required** | **Type** | **Description** |
|-----|-----|-----|-----|
|**Key** | | *String* | A unique identifier used to determine which fields need replacing. |
|**Value** | | *String* | The value that replaces the key. |

**MonopondStampMergeField (Mergefield) Parameters:**

|**Name** | **Required** | **Type** | **Description** |
|-----|-----|-----|-----|
|**Key** |  | *MonopondStampMergeFieldKey* | Contains x and y coordinates where the ImageValue or TextValue should be placed. |
|**TextValue** |  | *MonopondStampMergeFieldTextValue* | The text value that replaces the key. |
|**ImageValue** |  | *MonopondStampMergeFieldImageValue* | The image value that replaces the key. |

 **MonopondStampMergeFieldKey Parameters:**

| **Name** | **Required** | **Type** | **Description** |
|----|-----|-----|-----|
| **xCoord** |  | *Int* | X coordinate. |
| **yCoord** |  | *Int* | Y coordinate. |

**MonopondStampMergeFieldTextValue Parameters:**

|**Name** | **Required** | **Type** | **Description** |
|-----|-----|-----|-----|
|**fontName** |  | *String* | Font name to be used. |
|**fontSize** |  | *Decimal* | Font size to be used. |

**MonopondStampMergeFieldImageValue Parameters:**

|**Name** | **Required** | **Type** | **Description** |
|-----|-----|-----|-----|
|**fileName** |  | *String* | The document filename including extension. This is important as it is used to help identify the document MIME type. |
|**fileData** |  | *Base64* | The document encoded in Base64 format. |

**FaxDitheringTechnique:**

| Value | Fax Dithering Technique |
| --- | --- |
| **none** | No dithering. |
| **normal** | Normal dithering.|
| **turbo** | Turbo dithering.|
| **darken** | Darken dithering.|
| **darken_more** | Darken more dithering.|
| **darken_extra** | Darken extra dithering.|
| **ligthen** | Lighten dithering.|
| **lighten_more** | Lighten more dithering. |
| **crosshatch** | Crosshatch dithering. |
| **DETAILED** | Detailed dithering. |

**Resolution Levels:**

| **Value** | **Description** |
| --- | --- |
| **normal** | Normal standard resolution (98 scan lines per inch) |
| **fine** | Fine resolution (196 scan lines per inch) |

###Response
**MonopondFaxDocumentPreviewResponse Parameters:**

**Name** | **Type** | **Description** 
-----|-----|-----
**TiffPreview** | *String* | A preview version of the document encoded in Base64 format. 
**NumberOfPages** | *Int* | Total number of pages in the document preview.

###SOAP Faults
This function will throw one of the following SOAP faults/exceptions if something went wrong:
**DocumentRefDoesNotExistException**, **InternalServerException**, **UnsupportedDocumentContentType**, **MergeFieldDoesNotMatchDocumentTypeException**, **UnknownHostException**.
You can find more details on these faults in Section 5 of this document.You can find more details on these faults in the next section of this document.

###FaxDocumentPreview request with document reference
```ruby
//TODO: Setup FaxDocumentPreview request
@request = MonopondFaxDocumentPreviewRequest.new('test-sample-doc');
@response = @client.faxDocumentPreview(@request)
```

###FaxDocumentPreview request with microsoft word or pdf document reference, document merge fields, fine resolution and extra dark dithering technique
```ruby
//TODO: Identify 'mf:' key fields to be replaced
@docMergeField1 = MonopondDocMergeFieldKey.new("text1", "NewText1");
@docMergeField2 = MonopondDocMergeFieldKey.new("text2", "NewText2");

@docMergeFields = [];
@docMergeFields << @docMergeField1
@docMergeFields << @docMergeField2

//TODO: Setup FaxDocumentPreview request
@request = MonopondFaxDocumentPreviewRequest.new('test-sample-doc');
@request.docMergeData = @docMergeFields
@request.resolution = "FINE";
@request.ditheringTechnique = "DARKEN_EXTRA";
@response = @client.faxDocumentPreview(@request)
```

###FaxDocumentPreview request with tiff image document reference, fine resolution and extra dark dithering technique
```ruby
//TODO: Setup FaxDocumentPreview request
@request = MonopondFaxDocumentPreviewRequest.new('test-sample-tiff');
@request.resolution = "FINE";
@request.ditheringTechnique = "DARKEN_EXTRA";
@response = @client.faxDocumentPreview(@request)
```

###FaxDocumentPreview request with tiff image document reference, stamped texts, fine resolution and extra dark dithering technique
```ruby
//TODO: Setup stamped texts coordinates
@stampMergeFieldKey1 = MonopondStampMergeFieldKey.new(100, 200);
@stampMergeFieldKey2 = MonopondStampMergeFieldKey.new(143, 109);

//TODO: Setup stamped texts value
@stampMergeFieldTextValue1 = MonopondStampMergeFieldTextValue.new("text1", "Ubuntu-Bold", 14);
@stampMergeFieldTextValue2 = MonopondStampMergeFieldTextValue.new("text2", "Courier", 13);

//TODO: Setup StampMergeFields
@stampMergeField1 = MonopondStampMergeField.new;
@stampMergeField1.key = @stampMergeFieldKey1
@stampMergeField1.textValue = @stampMergeFieldTextValue1;

@stampMergeField2 = MonopondStampMergeField.new;
@stampMergeField2.key = @stampMergeFieldKey2
@stampMergeField2.textValue = @stampMergeFieldTextValue2;

@stampMergeFields = []
@stampMergeFields << @stampMergeField1;
@stampMergeFields << @stampMergeField2;

//TODO: Setup FaxDocumentPreview request
@request = MonopondFaxDocumentPreviewRequest.new('test-sample-tiff');
@request.stampMergeData = @stampMergeFields
@request.resolution = "FINE";
@request.ditheringTechnique = "DARKEN_EXTRA";
@response = @client.faxDocumentPreview(@request)
```

###FaxDocumentPreview request with pdf document reference, stamped images
```ruby
//TODO: Setup stamped images coordinates
@stampMergeFieldKey1 = MonopondStampMergeFieldKey.new(100, 200);
@stampMergeFieldKey2 = MonopondStampMergeFieldKey.new(143, 109);

//TODO: Setup stamped images fileName, base64Data, resized width and resized length
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

//TODO: Setup StampMergeFields
@stampMergeField1 = MonopondStampMergeField.new;
@stampMergeField1.key = @stampMergeFieldKey1
@stampMergeField1.imageValue = @stampMergeFieldImageValue1;

@stampMergeField2 = MonopondStampMergeField.new;
@stampMergeField2.key = @stampMergeFieldKey2
@stampMergeField2.imageValue = @stampMergeFieldImageValue2;

@stampMergeFields = []
@stampMergeFields << @stampMergeField1;
@stampMergeFields << @stampMergeField2;

//TODO: Setup FaxDocumentPreview request
@request = MonopondFaxDocumentPreviewRequest.new('test-sample-pdf');
@request.stampMergeData = @stampMergeFields
@response = @client.faxDocumentPreview(@request)
```

##SaveFaxDocument
###Description

This function allows you to upload a document and save it under a document reference (DocumentRef) for later use. (Note: These saved documents only last 30 days on the system.)

###Request
**MonopondSaveFaxDocumentRequest Parameters:**

| **Name** | **Required** | **Type** | **Description** |
|--- | --- | --- | --- | ---|
|**DocumentRef**| **X** | *String* | Unique identifier for the document to be uploaded. |
|**FileName**| **X** | *String* | The document filename including extension. This is important as it is used to help identify the document MIME type. |
| **FileData**|**X**| *Base64* |The document encoded in Base64 format.| |

###SOAP Faults
This function will throw one of the following SOAP faults/exceptions if something went wrong:
**DocumentRefAlreadyExistsException**, **DocumentContentTypeNotFoundException**, **InternalServerException**.
You can find more details on these faults in Section 5 of this document.You can find more details on these faults in the next section of this document.

###SaveFaxDocument request with pdf document reference
```ruby
//TODO: Setup SaveFaxDocument request document reference, fileName and base64 fileData
@request = MonopondSaveFaxDocumentRequest.new
@request.documentRef = "doc-ref-some-png";
@request.fileName = "logo_stamp1.png";
@request.fileData = "somebase64Data"
@response = @client.saveFaxDocument(@request)
```

##DeleteFaxDocument
###Description

This function removes a saved fax document from the system.

###Request
**MonopondDeleteFaxDocumentRequest Parameters:**

| **Name** | **Required** | **Type** | **Description** |
|--- | --- | --- | --- | ---|
|**DocumentRef**| **X** | *String* | Unique identifier for the document to be deleted. |

###SOAP Faults
This function will throw one of the following SOAP faults/exceptions if something went wrong:
**DocumentRefDoesNotExistException**, **InternalServerException**.
You can find more details on these faults in Section 5 of this document.You can find more details on these faults in the next section of this document.

###DeleteFaxDocument request with tiff document reference
```ruby
  @request = MonopondDeleteFaxDocumentRequest.new
  @request.documentRef = "doc-ref-some-png"
  @response = @client.deleteFaxDocument(@request)
```

#4.Callback Service
##Description
The callback service allows our platform to post fax results to you on fax message completion.

To take advantage of this, you are required to write a simple web service to accept requests from our system, parse them and update the status of the faxes on your system.

Once you have deployed the web service, please contact your account manager with the web service URL so they can attach it to your account. Once it is active, a request similar to the following will be posted to you on fax message completion:


```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<FaxMessage status="done" sendTo="61011111111" broadcastRef="test-1" sendRef="test-1-1" messageRef="test-1-1-1">
	<FaxResults>
		<FaxResult dateCallEnded="2012-08-02T13:27:18+08:00" dateCallStarted="2012-08-02T13:26:51+08:00" scheduledStartTime="2012-08-02T13:26:49.299+08:00" totalFaxDuration="27" pages="1" cost="0.15" result="success" attempt="1"/>
	</FaxResults>
</FaxMessage>
```

#5.More Information
##Exceptions/SOAP Faults
If an error occurs during a request on the Monopond Fax API the service will throw a SOAP fault or exception. Each exception is listed in detail below. To see which exceptions match up to the function calls please refer to the function descriptions in the previous sectionSection 3.
###InvalidArgumentsException
One or more of the arguments passed in the request were invalid. Each element that failed validation is included in the fault details along with the reason for failure.
###DocumentContentTypeNotFoundException
There was an error while decoding the document provided; we were unable to determine its content type.
###DocumentRefAlreadyExistsException
There is already a document on your account with this DocumentRef.
###DocumentContentTypeNotFoundException
Content type could not be found for the document.
###NoMessagesFoundException
Based on the references sent in the request no messages could be found that match the criteria.
###InternalServerException
An unusual error occurred on the platform. If this error occurs please contact support for further instruction.

##General Parameters and File Formatting
###File Encoding
All files are encoded in the Base64 encoding specified in RFC 2045 - MIME (Multipurpose Internet Mail Extensions). The Base64 encoding is designed to represent arbitrary sequences of octets in a form that need not be humanly readable. A 65-character subset ([A-Za-z0-9+/=]) of US-ASCII is used, enabling 6 bits to be represented per printable character. For more information see http://tools.ietf.org/html/rfc2045 and http://en.wikipedia.org/wiki/Base64

###Dates
Dates are always passed in ISO-8601 format with time zone. For example: “2012-07-17T19:27:23+08:00”
