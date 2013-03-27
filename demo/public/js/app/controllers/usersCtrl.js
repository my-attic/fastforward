window.UsersCtrl = Backbone.View.extend({},{//static
    
    model : new User({
        /* initialize fields values */
        firstName : 'firstName',lastName : 'lastName'

    }),
    
    collection : new Users(),

    //methods
    bindViews:function(){
        var self = this;

        UsersCtrl.collection.fetch({
            success:function(data){
                //console.log("-->",data);
                ko.applyBindings({ Users:kb.collectionObservable( UsersCtrl.collection) }, $("#listUsersView")[0]);
                ko.applyBindings(kb.viewModel( UsersCtrl.model), $("#formUserView")[0]);
                ko.applyBindings(kb.viewModel( UsersCtrl.model), $("#messageUserView")[0]);
            },
            error:function(err) { 
                //console.log("Err->",err);
                if(UsersCtrl.collection.length==0) {
                    ko.applyBindings({ Users:kb.collectionObservable( UsersCtrl.collection) }, $("#listUsersView")[0]);
                    ko.applyBindings(kb.viewModel( UsersCtrl.model), $("#formUserView")[0]);
                    ko.applyBindings(kb.viewModel( UsersCtrl.model), $("#messageUserView")[0]);                    
                } else {
                    throw "oups ..."
                }

            }

        });
    },
    addUser : function() {
        var tmpModel = UsersCtrl.model.clone();
        
        tmpModel.save({},{
            success:function(){
                UsersCtrl.collection.fetch({
                    success: function(data){/**/},
                    error: function(err){throw err;}
                });
            },
            error: function(err){throw err;}
        });
    },
    //called when link is clicked
    select : function(model) {
        var tmpModel = new User();
        tmpModel.set("id", model.id());
        tmpModel.fetch({ //GET
            success:function(){console.log(tmpModel);},
            error:function(err){throw err;}
        });
    },
    //called when delete link is clicked
    selectAndDelete : function(model) {

        var tmpModel = new User();
        tmpModel.set("id", model.id());

        console.log("DELETE : ", tmpModel)

        //DELETE
        tmpModel.destroy({
            success:function(){
                UsersCtrl.collection.fetch({
                    success: function(data){
                        console.log("Collections fetched after delete : ", data);
                    },
                    error: function(err){throw err;}
                });
            },
            error:function(err){throw err;}
        });

    }

});