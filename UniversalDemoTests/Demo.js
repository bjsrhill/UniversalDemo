/* This script contains the tests for Universal Demo */

DELAY_TIME=2
TEST_ADD_NAME="apple.com"
TEST_ADD_TITLE="Test Add"
TEST_ADD_NOTE="This is a test for adding a url record"
TEST_NAME="apple.com"
INVALID_TEST_NAME="apple.comJ"
TEST_TITLE="Web Resource"
INVALID_TEST_TITLE="Invalid Resource"
INVALID_TEST_NOTE="This is an invalid Resource"
TEST_NOTE="This is the main Apple website."
TEST_DETAIL="Web Resource"
TEST_MAIN="URL List"
TEST_ROW="apple.comJ"
INVALID_TEST_ROW="apple.com"
IPHONE_MODEL="iPhone"
IPAD_MODEL="iPad"
DELETE_VALID_TITLE="Test Add, apple.com"
DELETE_VALID_SWITCH="Delete Test Add, apple.com"
DELETE_VALID_CONFIRM="Confirm Deletion for Test Add, apple.com"
DELETE_INVALID_TITLE="Invalid Resource, apple.comJ"
DELETE_INVALID_SWITCH="Delete Invalid Resource, apple.comJ"
DELETE_INVALID_CONFIRM="Confirm Deletion for Invalid Resource, apple.comJ"

target = UIATarget.localTarget();
application = target.frontMostApp();
targetModel = target.model();
mainWindow = application.mainWindow();

/*
Create test data
*/
function addTestData(name,title,note)
{
	
	UIALogger.logMessage("Tapping + to add test row");
	application.navigationBar().rightButton().tap();
	table = mainWindow.tableViews()[0];
	urlTitle = table.cells()[0];
	urlName = table.cells()[1];
	urlNote = table.cells()[2];
	UIALogger.logMessage("About to update the input files to add a record.");
	urlTitle.textFields()[0].setValue(title);
	urlName.textFields()[0].setValue(name);
	urlNote.textViews()[0].setValue(note);
	UIALogger.logMessage("About to save record.");
	// Save the url record
	var tBar = table.toolbar().buttons()["Save"];
	if(tBar.isValid())
	{
		table.toolbar().buttons()["Save"].tap();	
	}
	else
	{
		application.navigationBar().buttons()["Save"].tap();
	}
}

/*
Delete test data
*/
function deleteTestData(title,switchVal,confirmVal)
{
	//Delete test data with the app on an iPad
	if(targetModel.indexOf(IPAD_MODEL) !=-1)
	{
		target.frontMostApp().navigationBar().buttons()["Url List"].tap();
		target.frontMostApp().mainWindow().popover().navigationBar().buttons()["Edit"].tap();
		target.frontMostApp().mainWindow().popover().tableViews()[0].cells()[title].switches()[switchVal].tap();
		target.frontMostApp().mainWindow().popover().tableViews()[0].cells()[title].buttons()[confirmVal].tap();
		target.frontMostApp().mainWindow().popover().navigationBar().buttons()["Done"].tap();
		target.frontMostApp().navigationBar().buttons()["Url List"].tap();
	}
	//Delete test data with the app on an iPhone
	else
	{
    	target.frontMostApp().navigationBar().buttons()["Edit"].tap();
    	target.frontMostApp().mainWindow().tableViews()[0].cells()[title].switches()[switchVal].tap();
    	target.frontMostApp().mainWindow().tableViews()[0].cells()[title].buttons()[confirmVal].tap();
    	target.frontMostApp().navigationBar().buttons()["Done"].tap();
	}
}

// assertion functions

/*
Asserts an equal expectation
*/
function assertEquals(expected, received, message) 
{
	if (received != expected) 
	{
		var fail = "Expected " + expected + " but received " + received;
		UIALogger.logFail(fail);
	}
	else
	{
		UIALogger.logPass(message);
	}
}

/*
Asserts an true expectation
*/
function assertTrue(expression, message) 
{
	if (! expression) 
	{
		var fail = "Assertion failed";
		UIALogger.logFail(fail);
	}
	else
	{
		UIALogger.logPass(message);
	}
}

/*
Asserts an false expectation
*/
function assertFalse(expression, message) 
{
	assertTrue(! expression, message);
}

/*
Asserts an non null expectation
*/
function assertNotNull(thingie, message) 
{
	if (thingie == null || thingie.toString() == "[object UIAElementNil]") 
	{
        var fail = "Expected not null object";
        UIALogger.logFail(fail);
	}
	else
	{
		UIALogger.logPass(message);
	}
}

/*
Asserts that an object is valid
*/
function assertIsValid(object, message)
{
	if(! object.isValid())
	{
		var fail = "Object is not valid";
        UIALogger.logFail(fail);
	}
	else
	{
		UIALogger.logPass(message);
	}
}

/*
Asserts that an object is enabled
*/
function assertIsEnabled(object, message)
{
	if(! object.isEnabled())
	{
		var fail = "Object is not enabled";
        UIALogger.logFail(fail);
	}
	else
	{
		UIALogger.logPass(message);
	}
}

/*
Asserts that an object is not enabled
*/
function assertIsNotEnabled(object, message)
{
	if(object.isEnabled())
	{
		var fail = "Object is enabled";
        UIALogger.logFail(fail);
	}
	else
	{
		UIALogger.logPass(message);
	}
}

// Tests

/* 
 Tests that a Url name value is persisted to a database
 */
function testUrlNameExists()
{
	UIALogger.logMessage("Adding a test record");
	addTestData(TEST_ADD_NAME,TEST_ADD_TITLE,TEST_ADD_NOTE);
    var testName = "testUrlNameExists";
    UIALogger.logStart(testName);
	// iPad test
	if(targetModel.indexOf(IPAD_MODEL) !=-1)
	{
		UIALogger.logMessage("Getting to the entry form");
		target.frontMostApp().navigationBar().buttons()["Url List"].tap();
		target.frontMostApp().mainWindow().popover().tableViews()[0].cells()[DELETE_VALID_TITLE].tap();
		target.delay(DELAY_TIME);
		target.frontMostApp().navigationBar().buttons()["Add"].tap();
		table = mainWindow.tableViews()[0];
		var name =table.cells()[1];
		var textName = name.textFields()[0].value();
		//target.frontMostApp().mainWindow().tableViews()[0].cells()["URL"].textFields()[0].tap();
		target.frontMostApp().mainWindow().tableViews()[0].toolbar().buttons()["Cancel"].tap();
		assertEquals(textName,TEST_ADD_NAME,"The name value is " + textName);
	}
	// iPhone test
	else
	{
		UIALogger.logMessage("Getting to the entry form");
		target.frontMostApp().mainWindow().tableViews()[0].cells()[DELETE_VALID_TITLE].tap();
		target.delay(DELAY_TIME);
		target.frontMostApp().navigationBar().buttons()["Edit"].tap();
		table = mainWindow.tableViews()[0];
		var name =table.cells()[1];
		var textName = name.textFields()[0].value();
		target.frontMostApp().navigationBar().buttons()["Cancel"].tap();
		target.frontMostApp().navigationBar().buttons()["URL List"].tap();
		assertEquals(textName,TEST_ADD_NAME,"The name value is " + textName);
	}

    UIALogger.logMessage("Deleting a test record");
    deleteTestData(DELETE_VALID_TITLE, DELETE_VALID_SWITCH, DELETE_VALID_CONFIRM);
}

/* 
 Tests that a Url title value is persisted to a database
 */
function testUrlTitleExists()
{
	UIALogger.logMessage("Adding a test record");
	addTestData(TEST_ADD_NAME, TEST_ADD_TITLE,TEST_ADD_NOTE);
    var testName = "testUrlTitleExists";
    UIALogger.logStart(testName);
	// iPad test
	if(targetModel.indexOf(IPAD_MODEL) !=-1)
	{
		UIALogger.logMessage("Getting to the entry form");
		target.frontMostApp().navigationBar().buttons()["Url List"].tap();
		target.frontMostApp().mainWindow().popover().tableViews()[0].cells()[DELETE_VALID_TITLE].tap();
		target.delay(DELAY_TIME);
		target.frontMostApp().navigationBar().buttons()["Add"].tap();
		table = mainWindow.tableViews()[0];
		var title =table.cells()[0];
		var textTitle = title.textFields()[0].value();
		target.frontMostApp().mainWindow().tableViews()[0].cells()["URL"].textFields()[0].tap();
		target.frontMostApp().mainWindow().tableViews()[0].toolbar().buttons()["Cancel"].tap();
		assertEquals(textTitle,TEST_ADD_TITLE,"The title value is " + textTitle);
	}
	// iPhone test
	else
	{
		UIALogger.logMessage("Getting to the entry form");
		target.frontMostApp().mainWindow().tableViews()[0].cells()[DELETE_VALID_TITLE].tap();
		target.delay(DELAY_TIME);
		target.frontMostApp().navigationBar().buttons()["Edit"].tap();
		table = mainWindow.tableViews()[0];
		var title =table.cells()[0];
		var textTitle = title.textFields()[0].value();
		target.frontMostApp().navigationBar().buttons()["Cancel"].tap();
		target.frontMostApp().navigationBar().buttons()["URL List"].tap();
		assertEquals(textTitle,TEST_ADD_TITLE,"The title value is " + textTitle);
	}

    UIALogger.logMessage("Deleting a test record");
    deleteTestData(DELETE_VALID_TITLE, DELETE_VALID_SWITCH, DELETE_VALID_CONFIRM);
}

/* 
 Tests that a Url note value is persisted to a database
 */
function testUrlNoteExists()
{
	UIALogger.logMessage("Adding a test record");
	addTestData(TEST_ADD_NAME, TEST_ADD_TITLE,TEST_ADD_NOTE);
    var testName = "testUrlNoteExists";
    UIALogger.logStart(testName);
	// iPad test
	if(targetModel.indexOf(IPAD_MODEL) !=-1)
	{
		UIALogger.logMessage("Getting to the entry form");
		target.frontMostApp().navigationBar().buttons()["Url List"].tap();
		target.frontMostApp().mainWindow().popover().tableViews()[0].cells()[DELETE_VALID_TITLE].tap();
		target.delay(DELAY_TIME);
		target.frontMostApp().navigationBar().buttons()["Add"].tap();
		table = mainWindow.tableViews()[0];
		var note =table.cells()[2];
		var textNote = note.textViews()[0].value();
		target.frontMostApp().mainWindow().tableViews()[0].cells()["URL"].textFields()[0].tap();
		target.frontMostApp().mainWindow().tableViews()[0].toolbar().buttons()["Cancel"].tap();
		assertEquals(textNote,TEST_ADD_NOTE,"The title value is " + textNote);
	}
	// iPhone test
	else
	{
		UIALogger.logMessage("Getting to the entry form");
		target.frontMostApp().mainWindow().tableViews()[0].cells()[DELETE_VALID_TITLE].tap();
		target.delay(DELAY_TIME);
		target.frontMostApp().navigationBar().buttons()["Edit"].tap();
		table = mainWindow.tableViews()[0];
		var note =table.cells()[2];
		var textNote = note.textViews()[0].value();
		target.frontMostApp().navigationBar().buttons()["Cancel"].tap();
		target.frontMostApp().navigationBar().buttons()["URL List"].tap();
		assertEquals(textNote,TEST_ADD_NOTE,"The name value view is " + textNote);
	}
    UIALogger.logMessage("Deleting a test record");
    deleteTestData(DELETE_VALID_TITLE, DELETE_VALID_SWITCH, DELETE_VALID_CONFIRM);
}


/* 
 Tests that a detail view is valid
 */
function testShowDetail()
{
    UIALogger.logMessage("Adding a test record");
    addTestData(TEST_ADD_NAME, TEST_ADD_TITLE,TEST_ADD_NOTE);
    var testName = "testShowDetail";
    UIALogger.logStart(testName);
    // iPad test
	if(targetModel.indexOf(IPAD_MODEL) !=-1)
	{
		UIALogger.logMessage("Getting to the entry form");
		target.frontMostApp().navigationBar().buttons()["Url List"].tap();
		target.frontMostApp().mainWindow().popover().tableViews()[0].cells()[DELETE_VALID_TITLE].tap();
		target.delay(DELAY_TIME);
        var webview = target.frontMostApp().mainWindow().scrollViews()[0].webViews()[0]
        assertNotNull(webview,"The textView is valid.");
	}
	// iPhone test
	else
	{
        target.frontMostApp().mainWindow().tableViews()[0].cells()[DELETE_VALID_TITLE].tap();
        target.delay(DELAY_TIME);
        var webview = target.frontMostApp().mainWindow().scrollViews()[0].webViews()[0]
        assertNotNull(webview,"The textView is valid.");
        target.frontMostApp().navigationBar().buttons()["URL List"].tap();
    }
	UIALogger.logMessage("Deleting a test record");
	deleteTestData(DELETE_VALID_TITLE, DELETE_VALID_SWITCH, DELETE_VALID_CONFIRM);
}

/* 
 Tests that the url list screen has a correct title 
 */
function testMainViewTitle()
{
    UIALogger.logMessage("Adding a test record");
    addTestData(TEST_ADD_NAME, TEST_ADD_TITLE,TEST_ADD_NOTE);
    var testName = "testMainViewTitle";
    UIALogger.logStart(testName);
    // iPad test
    if(targetModel.indexOf(IPAD_MODEL) !=-1)
    {
		UIALogger.logMessage("Changing to landscape.");
		target.setDeviceOrientation(UIA_DEVICE_ORIENTATION_LANDSCAPELEFT);
		target.delay(DELAY_TIME);
        if(application.navigationBar().name() == TEST_MAIN)
		{
			UIALogger.logPass("The title of the main view is " + TEST_MAIN);
		}
       	else
		{
			UIALogger.logFail("The title of the main view is not " + TEST_MAIN + ". It is " + application.navigationBar().name());
		}
		UIALogger.logMessage("Changing to portrait");
		target.setDeviceOrientation(UIA_DEVICE_ORIENTATION_PORTRAIT);
		target.delay(DELAY_TIME);
		if(application.navigationBar().name() == TEST_DETAIL)
		{
			UIALogger.logPass("The title of the detail view is " + TEST_DETAIL);
		}
       	else
		{
			UIALogger.logFail("The title of the detail view is not " + TEST_DETAIL + ". It is " + application.navigationBar().name());
		}
    }
	// iPhone test
	else
	{   
        assertEquals(application.navigationBar().name(),TEST_MAIN,"The title of the main view is " + application.navigationBar().name());
    }
    UIALogger.logMessage("Deleting a test record");
    deleteTestData(DELETE_VALID_TITLE, DELETE_VALID_SWITCH, DELETE_VALID_CONFIRM);
}

/* 
 Tests that the detail screen has a correct title 
 */
function testDetailViewTitle()
{
    UIALogger.logMessage("Adding a test record");
    addTestData(TEST_ADD_NAME, TEST_ADD_TITLE,TEST_ADD_NOTE);
    var testName = "testDetailViewTitle";
    UIALogger.logStart(testName);
    // iPad test
    if(targetModel.indexOf(IPAD_MODEL) !=-1)
    {
		UIALogger.logMessage("Getting to the entry form");
		target.frontMostApp().navigationBar().buttons()["Url List"].tap();
		target.frontMostApp().mainWindow().popover().tableViews()[0].cells()[DELETE_VALID_TITLE].tap();
		target.delay(DELAY_TIME);
        assertEquals(application.navigationBar().name(),TEST_DETAIL,"The title of the detail view is " + application.navigationBar().name());
    }
	// iPhone test
	else
	{   
        target.frontMostApp().mainWindow().tableViews()[0].cells()[DELETE_VALID_TITLE].tap();
        target.delay(DELAY_TIME);
        assertEquals(application.navigationBar().name(),TEST_DETAIL,"The title of the detail view is " + application.navigationBar().name());
        target.frontMostApp().navigationBar().buttons()["URL List"].tap();
    }
    UIALogger.logMessage("Deleting a test record");
    deleteTestData(DELETE_VALID_TITLE, DELETE_VALID_SWITCH, DELETE_VALID_CONFIRM);
}


/* 
 Tests that a message displays on the detail screen when an invalid URL is selected
 */
function testInvalidDetail()
{
	UIALogger.logMessage("Adding a test record");
	addTestData(INVALID_TEST_NAME, INVALID_TEST_TITLE,INVALID_TEST_NOTE);
    var testName = "testInvalidDetail";
    UIALogger.logStart(testName);
	// iPad test
    if(targetModel.indexOf(IPAD_MODEL) !=-1)
    {
		UIALogger.logMessage("Getting to the entry form");
		target.frontMostApp().navigationBar().buttons()["Url List"].tap();
		target.frontMostApp().mainWindow().popover().tableViews()[0].cells()[DELETE_INVALID_TITLE].tap();
		target.delay(DELAY_TIME);
		var invalidMessage = target.frontMostApp().mainWindow().textViews()[0].value();
		assertEquals(invalidMessage,"Failed to load page: A server with the specified hostname could not be found.","The webview error message is " + invalidMessage);
		UIALogger.logMessage("Deleting a test record");
    }
	// iPhone test
	else
	{   
		target.frontMostApp().mainWindow().tableViews()[0].cells()[DELETE_INVALID_TITLE].tap();
    	target.delay(DELAY_TIME);
		var invalidMessage = target.frontMostApp().mainWindow().textViews()[0].value();
		assertEquals(invalidMessage,"Failed to load page: A server with the specified hostname could not be found.","The webview error message is " + invalidMessage);
		UIALogger.logMessage("Deleting a test record");
		target.frontMostApp().navigationBar().buttons()["URL List"].tap();
	}
	UIALogger.logMessage("Deleting a test record");
	deleteTestData(DELETE_INVALID_TITLE, DELETE_INVALID_SWITCH, DELETE_INVALID_CONFIRM);
}

/* 
 Tests to ascertain that a list of added Url names is available.
 */
function testShowList()
{
     UIALogger.logMessage("Adding a test record");
     addTestData(TEST_ADD_NAME, TEST_ADD_TITLE,TEST_ADD_NOTE);
     var testName = "testShowList";
     UIALogger.logStart(testName);	
	// iPad test
	if(targetModel.indexOf(IPAD_MODEL) !=-1)
	{
		UIALogger.logMessage("Changing to landscape for landscape testing.");
		target.setDeviceOrientation(UIA_DEVICE_ORIENTATION_LANDSCAPELEFT);
		target.delay(DELAY_TIME);
        //do landscape testing
		target.delay(DELAY_TIME);
    	UIALogger.logMessage("Locating the test record to display detail.");
		var cell = table.cells().firstWithPredicate("name beginswith  '" + DELETE_VALID_TITLE + "'");
		target.delay(DELAY_TIME);
		if(cell.isValid())
		{
			UIALogger.logPass("There is a url list");
		}
		else
		{
			UIALogger.logFail("There is no url list");
		}
		UIALogger.logMessage("Changing to portrait.");
		target.setDeviceOrientation(UIA_DEVICE_ORIENTATION_PORTRAIT);
	}
	// iPhone test
	else
	{   
		var cell = target.frontMostApp().mainWindow().tableViews()[0].cells()[DELETE_VALID_TITLE];
		assertIsValid(cell,"Ths URL list cell is valid.");
	}
	UIALogger.logMessage("Deleting a test record");
	deleteTestData(DELETE_VALID_TITLE, DELETE_VALID_SWITCH, DELETE_VALID_CONFIRM);
}

/* 
 Tests to ascertain that that there is a back page navigation on the web view
 */
function testGoBack()
{
     UIALogger.logMessage("Adding a test record");
     addTestData(TEST_ADD_NAME, TEST_ADD_TITLE,TEST_ADD_NOTE);
     var testName = "testGoBack";
     UIALogger.logStart(testName);
     // iPad test
    if(targetModel.indexOf(IPAD_MODEL) !=-1)
    {
		UIALogger.logMessage("Getting to the entry form");
		target.frontMostApp().navigationBar().buttons()["Url List"].tap();
		target.frontMostApp().mainWindow().popover().tableViews()[0].cells()[DELETE_VALID_TITLE].tap();
		target.delay(DELAY_TIME);
		target.frontMostApp().mainWindow().scrollViews()[0].webViews()[0].links()["Store\n"].tap();
		target.delay(DELAY_TIME);
		target.delay(DELAY_TIME);
		target.delay(DELAY_TIME);
		var backButton = target.frontMostApp().toolbar().buttons()["icon back"];
		assertIsEnabled(backButton,"Back button was enabled");
    }
    // iPhone test
    else
    {   
		target.frontMostApp().mainWindow().tableViews()[0].cells()[DELETE_VALID_TITLE].tap();
    	target.delay(DELAY_TIME);
		target.frontMostApp().mainWindow().scrollViews()[0].webViews()[0].links()["Store\n"].tap();
		target.delay(DELAY_TIME);
		target.delay(DELAY_TIME);
		target.delay(DELAY_TIME);
		var backButton = target.frontMostApp().toolbar().buttons()["icon back"];
		target.frontMostApp().navigationBar().buttons()["URL List"].tap();
		assertIsEnabled(backButton,"Back button was enabled");
    }
    UIALogger.logMessage("Deleting a test record");
    deleteTestData(DELETE_VALID_TITLE, DELETE_VALID_SWITCH, DELETE_VALID_CONFIRM);
}

/* 
 Tests to ascertain that that there is a forward page navigation on the web view
 */
function testGoForward()
{
     UIALogger.logMessage("Adding a test record");
     addTestData(TEST_ADD_NAME, TEST_ADD_TITLE,TEST_ADD_NOTE);
     var testName = "testGoForward";
     UIALogger.logStart(testName);
     // iPad test
    if(targetModel.indexOf(IPAD_MODEL) !=-1)
    {
       	UIALogger.logMessage("Getting to the entry form");
		target.frontMostApp().navigationBar().buttons()["Url List"].tap();
		target.frontMostApp().mainWindow().popover().tableViews()[0].cells()[DELETE_VALID_TITLE].tap();
		target.delay(DELAY_TIME);
		target.frontMostApp().mainWindow().scrollViews()[0].webViews()[0].links()["Store\n"].tap();
		target.delay(DELAY_TIME);
		target.frontMostApp().toolbar().buttons()["icon back"].tap();
		target.delay(DELAY_TIME);
		target.delay(DELAY_TIME);
		var forwardButton = target.frontMostApp().toolbar().buttons()["icon forward"];
		assertIsEnabled(forwardButton,"Forward button was enabled");
    }
    // iPhone test
    else
    {   
		target.frontMostApp().mainWindow().tableViews()[0].cells()[DELETE_VALID_TITLE].tap();
    	target.delay(DELAY_TIME);
		target.frontMostApp().mainWindow().scrollViews()[0].webViews()[0].links()["Store\n"].tap();
		target.delay(DELAY_TIME);
		target.frontMostApp().toolbar().buttons()["icon back"].tap();
		target.delay(DELAY_TIME);
		target.delay(DELAY_TIME);
		target.delay(DELAY_TIME);
		var forwardButton = target.frontMostApp().toolbar().buttons()["icon forward"];
		target.frontMostApp().navigationBar().buttons()["URL List"].tap();
		assertIsEnabled(forwardButton,"Forward button was enabled");
    }
    UIALogger.logMessage("Deleting a test record");
    deleteTestData(DELETE_VALID_TITLE, DELETE_VALID_SWITCH, DELETE_VALID_CONFIRM);
}

/* 
 Tests to ascertain that that there is a stop page navigation on the web view
 */
function testStop()
{
     UIALogger.logMessage("Adding a test record");
     addTestData(TEST_ADD_NAME, TEST_ADD_TITLE,TEST_ADD_NOTE);
     var testName = "testStop";
     UIALogger.logStart(testName);
     // iPad test
    if(targetModel.indexOf(IPAD_MODEL) !=-1)
    {
        UIALogger.logMessage("Getting to the entry form");
		target.frontMostApp().navigationBar().buttons()["Url List"].tap();
		target.frontMostApp().mainWindow().popover().tableViews()[0].cells()[DELETE_VALID_TITLE].tap();
		target.delay(DELAY_TIME);
		target.frontMostApp().mainWindow().scrollViews()[0].webViews()[0].links()["Store\n"].tap();
		target.delay(DELAY_TIME);
		target.frontMostApp().toolbar().buttons()["Refresh"].tap();
		var stop = target.frontMostApp().toolbar().buttons()["Stop"];
		target.frontMostApp().toolbar().buttons()["Stop"].tap();
		var checkEnabled = stop.isEnabled();
		assertTrue(checkEnabled,"Stop button was enabled");
    }
    // iPhone test
    else
    {   
		target.frontMostApp().mainWindow().tableViews()[0].cells()[DELETE_VALID_TITLE].tap();
    	target.delay(DELAY_TIME);
		target.frontMostApp().mainWindow().scrollViews()[0].webViews()[0].links()["Store\n"].tap();
		target.delay(DELAY_TIME);
		target.frontMostApp().toolbar().buttons()["Refresh"].tap();
		var stop = target.frontMostApp().toolbar().buttons()["Stop"];
		target.frontMostApp().toolbar().buttons()["Stop"].tap();
		var checkEnabled = stop.isEnabled();
		target.frontMostApp().navigationBar().buttons()["URL List"].tap();
		assertTrue(checkEnabled,"Stop button was enabled");
    }
    UIALogger.logMessage("Deleting a test record");
    deleteTestData(DELETE_VALID_TITLE, DELETE_VALID_SWITCH, DELETE_VALID_CONFIRM);
}

/* 
 Tests to ascertain that that there is a reload page navigation on the web view
 */
function testReload()
{
     UIALogger.logMessage("Adding a test record");
     addTestData(TEST_ADD_NAME, TEST_ADD_TITLE,TEST_ADD_NOTE);
     var testName = "testReload";
     UIALogger.logStart(testName);
     // iPad test
    if(targetModel.indexOf(IPAD_MODEL) !=-1)
    {
        UIALogger.logMessage("Getting to the entry form");
		target.frontMostApp().navigationBar().buttons()["Url List"].tap();
		target.frontMostApp().mainWindow().popover().tableViews()[0].cells()[DELETE_VALID_TITLE].tap();
		target.delay(DELAY_TIME);
		var reload = target.frontMostApp().toolbar().buttons()["Refresh"];
		var checkEnabled = reload.isEnabled();
		assertTrue(checkEnabled,"Reload button was enabled");
    }
    // iPhone test
    else
    {   
		target.frontMostApp().mainWindow().tableViews()[0].cells()[DELETE_VALID_TITLE].tap();
		target.delay(DELAY_TIME);
		var reload = target.frontMostApp().toolbar().buttons()["Refresh"];
		var checkEnabled = reload.isEnabled();
		target.frontMostApp().navigationBar().buttons()["URL List"].tap();
		assertTrue(checkEnabled,"Reload button was enabled");
    }
    UIALogger.logMessage("Deleting a test record");
    deleteTestData(DELETE_VALID_TITLE, DELETE_VALID_SWITCH, DELETE_VALID_CONFIRM);
}

/* 
 Tests that a complete URL record can be added through the application
 */
function testAddURLRecord()
{
	UIALogger.logMessage("Adding a test record");
	addTestData(INVALID_TEST_NAME, INVALID_TEST_TITLE,INVALID_TEST_NOTE);
    var testName = "testAddURLRecord";
    UIALogger.logStart(testName);
	// iPad test
    if(targetModel.indexOf(IPAD_MODEL) !=-1)
    {
        UIALogger.logMessage("Getting to the entry form");
		target.frontMostApp().navigationBar().buttons()["Url List"].tap();
		target.frontMostApp().mainWindow().popover().tableViews()[0].cells()[DELETE_INVALID_TITLE].tap();
		target.delay(DELAY_TIME);
		target.frontMostApp().navigationBar().buttons()["Add"].tap();
		table = mainWindow.tableViews()[0];
		var name =table.cells()[1];
		var textName = name.textFields()[0].value();
        var title =table.cells()[0];
		var textTitle = title.textFields()[0].value();
        var note =table.cells()[2];
		var textNote = note.textViews()[0].value();
        var nameEquals = (textName === INVALID_TEST_NAME);
        var titleEquals = (textTitle === INVALID_TEST_TITLE);
        var noteEquals = (textNote === INVALID_TEST_NOTE);
        target.frontMostApp().mainWindow().tableViews()[0].toolbar().buttons()["Cancel"].tap();
        if(nameEquals && titleEquals && noteEquals)
        {
            UIALogger.logPass("The record was added and retrieved");
        }
        else
        {
            UIALogger.logFail("The record was not added and retrieved");
        }
		
		
    }
	// iPhone test
	else
	{   
		UIALogger.logStart(testName);
		target.frontMostApp().mainWindow().tableViews()[0].cells()[DELETE_INVALID_TITLE].tap();
    	target.delay(DELAY_TIME);
        target.frontMostApp().navigationBar().buttons()["Edit"].tap();
		table = mainWindow.tableViews()[0];
		var name =table.cells()[1];
		var textName = name.textFields()[0].value();
        var title =table.cells()[0];
		var textTitle = title.textFields()[0].value();
        var note =table.cells()[2];
		var textNote = note.textViews()[0].value();
        var nameEquals = (textName === INVALID_TEST_NAME);
        var titleEquals = (textTitle === INVALID_TEST_TITLE);
        var noteEquals = (textNote === INVALID_TEST_NOTE);
        target.frontMostApp().navigationBar().buttons()["Cancel"].tap();
		target.frontMostApp().navigationBar().buttons()["URL List"].tap();
        if(nameEquals && titleEquals && noteEquals)
        {
            UIALogger.logPass("The record was added and retrieved");
        }
        else
        {
            UIALogger.logFail("The record was not added and retrieved");
        }
	}
	UIALogger.logMessage("Deleting a test record");
	deleteTestData(DELETE_INVALID_TITLE, DELETE_INVALID_SWITCH, DELETE_INVALID_CONFIRM);
}

testUrlNameExists();

testUrlTitleExists();

testUrlNoteExists();

testMainViewTitle();

testDetailViewTitle();

testShowDetail();

testInvalidDetail();

testShowList();

testGoBack();

testGoForward();

testStop();

testReload();

testAddURLRecord();


