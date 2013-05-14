RK-AtomicUpdate
===============

A objc-category supporting atomic updates with Core Data and Reskit.
It will only send the changed attributes to the server, in a PATCH request.

##Features
- Seamlessly integrates with Restkit 0.20.0
- Detects changes in normal attributes
- Detects changes in one-to-many relations
- Detects changes in one-to-one relations
- Respects your mapping

##Requirements / limitations
- Only works with Core Data objects

##How it works
RK-AtomicUpdate automatically sees what attributes you have changed in core data since the last save.

So let's say you have this object in core data:
	
	{
		first_name: "Peter",
		last_name: "Willemsen",
		note: "A programmer"
	}
	
And change note from a "A programmer" to "A great programmer" and then use atomicPatchObject instead of the regular patchObject from RestKit, it creates a PATCH request containing these parameters:

	{
		note: "A great programmer"
	}

So instead of sending the whole object again you saved yourself some bytes ;)
It also lowers the chance of conflicting in case when you have a offline mode

##Real life uses

- 54Ops (coming soon, check out http://54limited.com for more info)
- TogetherNow (coming soon, check out http://togethernowapp.com for more info and a beta request)


##Installation

Import RKObjectManager+AtomicUpdate.h to the file where you want to send only the changed attributes.

Call it like this:

	RKObjectManager *objectManager = <your RKObjectManager instance>;
	[objectManager atomicPatchObject:self path:@"<Your url to PATCH to>" parameters:nil success:^(AFHTTPRequestOperation *operation) {
    
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
	
	}];