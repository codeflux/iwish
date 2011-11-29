iWish
====

_The iOS API wrappers and additions you wish somebody made_


Purpose
------------

Apple has done a good job of providing a very robust API, but using it properly is no small feat.

Other open source API's try to provide canned solutions to common tasks. However, from our experience, we spend more time writing custom code or customizing these open source API's.

iWish is a project with one goal in mind: to make iOS development really simple. For most scenarios, we don't need all the power of Apple's API. And we usually have to write alot of stuff to implement simple things.

We try to strike a balance between power and simplicity.


Requirements
-------------------

iOS 5. It only works on an ARC-compliant project.


Installation
---------------

All of the classes to be imported are in the Classes folder. At the minimum, copy the IWCommon folder into your project.


Features
------------

* Category-based extensions to the existing iOS API's.
* Simplified HTTP operations via IWHttpLib


Available API's
--------------------

*	IWCommon
	*	Categories that extend the existing iOS API's. These are required by all the other wrapper API's.
	
*	IWHttpLib
	*	Wrapper for NSURLConnection, used for making asynchronous HTTP requests.
	*	Supports GET and POST
	*	Supports saving large files directly to the file system


Usage
---------

**IWHttpLib**

There is one class you need to know: `IWHttpRequest`. Please take note that instances of this class should not be reused after each request.

At its simplest form:

	IWHttpRequest *request=[IWHttpRequest requestWithStringURL:@"http://www.google.com/search?q=iwish"];
	[request sendRequest];

If you want to automate the creation of the query string and make the request via GET:

	IWHttpRequest *request=[IWHttpRequest requestWithStringURL:@"http://google.com"];
	
	[request setValue:@"iwish" forRequestParameter:@"q"];
	
	[request sendRequest];

If you want to make the request via POST:

	IWHttpRequest *request=[IWHttpRequest requestWithStringURL:@"http://google.com"];
	
	[request setValue:@"iwish" forRequestParameter:@"q"];
	request.POST=YES;
	
	[request sendRequest];
	
If you have a dictionary of strings that you want to use as the request parameters:

	NSDictionary *parameters=[NSDictionary dictionaryWithObject:@"iwish" forKey:@"q"];
	
	IWHttpRequest *request=[IWHttpRequest requestWithStringURL:@"http://google.com"];
	
	request.requestParameters=parameters;
	
	[request sendRequest];

You want to save the result to a file? No problem:

	IWHttpRequest *request=[IWHttpRequest requestWithStringURL:@"http://www.google.com/search?q=iwish"];
	
	request.downloadFilePath=@"/path/to/file";
	
	[request sendRequest];

Need to set a callback when the request completes? `IWHttpRequest` supports 3 kinds of callbacks:

	IWHttpRequest *request=[IWHttpRequest requestWithStringURL:@"http://www.google.com/search?q=iwish"];

	request.successBlock=^{
		// triggered when it receives a status code of 200 (HTTP code for success)
	};
	request.failBlock=^{
		// triggered when the request fails for any reason.
	};
	request.finallyBlock=^{
		// triggered regardless of the status of the request.
	};
	
	[request sendRequest];

Need to access the various properties like the response data, error, and the response object?

	__weak IWHttpRequest *request=[IWHttpRequest requestWithStringURL:@"http://www.google.com/search?q=iwish"];

	request.finallyBlock=^{
		NSURLResponse *response=request.response;
		NSData *responseData=request.responseData;
		NSError *error=request.error;
	};
	
	[request sendRequest];

_Take note: to avoid problems when using blocks, declare the request instance as weak._

When you need to call a method in the owning class, do this:

	__weak IWHttpRequest *request=[IWHttpRequest requestWithStringURL:@"http://www.google.com/search?q=iwish"];
	__weak MyCurrentClass *currentObject=self;

	request.finallyBlock=^{
		[currentObject myMethod];
	};
	
	[request sendRequest];