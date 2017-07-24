@isTest
private class AngularCtrl_Test {

	private static testMethod void testSimpleCreatePost() {
        Test.startTest();
        AngularCtrl.createPost('String text');
        Test.stopTest();
        system.assertEquals(1, [SELECT Id FROM FeedItem LIMIT 10].size());
	}
	
    private static testMethod void testBlankCreatePost() {
        Test.startTest();
        map<String, Object> output = AngularCtrl.createPost(null);
        String status = String.valueOf(output.get('status'));
        system.assertEquals('failure', status);
        Test.stopTest();
        system.assertEquals(0, [SELECT Id FROM FeedItem LIMIT 10].size());
	}
	
	private static testMethod void testGetFeed() {
	    insert new list<FeedItem>{
	        new FeedItem(ParentId = UserInfo.getUserId(), Body = 'Test 1'),  
	        new FeedItem(ParentId = UserInfo.getUserId(), Body = 'Test 2'),  
	        new FeedItem(ParentId = UserInfo.getUserId(), Body = 'Test 3')
	    };
        Test.startTest();
        list<AngularCtrl.ChatterFeedItem> items = AngularCtrl.getFeed();
        Test.stopTest();
        system.assertEquals(3, items.size());
	}

}