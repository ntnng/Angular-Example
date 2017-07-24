public with sharing class AngularCtrl {
    
    @RemoteAction
    public static list<ChatterFeedItem> getFeed() {
        list<ChatterFeedItem> items = new list<ChatterFeedItem>();
        set<Id> userIds = new set<Id>();
        for (FeedItem fItem : [SELECT ID, CreatedDate, CreatedById, CreatedBy.Name, ParentId, Parent.Name, Body FROM FeedItem WHERE Type = 'TextPost' ORDER BY CreatedDate DESC LIMIT 100] ) {
             items.add(new ChatterFeedItem(fItem)); 
             userIds.add(fItem.CreatedById);
             if (fItem.ParentId.getSObjectType() == User.SobjectType) {
                userIds.add(fItem.ParentId);
             }
        }
        if (userIds.size() > 0) {
            map<Id, User> users = new map<Id, User>([SELECT Id, SmallPhotoUrl FROM User WHERE Id =: userIds]);
            for (ChatterFeedItem item : items) {
                item.setPhotoUrl(users.get(item.postCreatorId).SmallPhotoUrl);
            }
        }
        
        return items;
    }

    @RemoteAction
    public static map<String, Object> createPost(String text) {
        try {
            FeedItem post = new FeedItem();
            post.ParentId = UserInfo.getUserId();
            post.Body = text;
            insert post;
            return new map<String, Object>{
                'status' => 'success',
                'message' => 'Record created successfully!',
                'recordId' => post.Id
            };
        } catch (Exception ex) {
            system.debug(ex.getMessage());
            return new map<String, Object> {
                'status' => 'failure',
                'message' => ex.getMessage()
            };
        }
    }
    
    public class ChatterFeedItem {
        String postBody;
        String postCreatorName;
        String postCreatorId;
        String postCreatorPhoto;
        String postId;
        String postDate;
        public ChatterFeedItem(FeedItem fItem) {
            this.postId = fItem.Id;
            this.postCreatorId = fItem.ParentId;
            this.postCreatorName = fItem.Parent.Name;
            this.postBody = fItem.Body;
            this.postDate = fItem.CreatedDate.format();
        }
        
        public void setPhotoUrl(String photoUrl) {
            this.postCreatorPhoto = photoUrl;
        }
    }
}