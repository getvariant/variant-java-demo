![Variant Logo](http://www.getvariant.com/wp-content/uploads/2016/07/VariantLogoSquare-100.png)

# Variant Experiment Server Demo Application
### Release 0.9.3
#### Requires: 
* [Variant Java Client 0.9.3](https://www.getvariant.com/resources/docs/0-9/clients/variant-java-client/)
* [Variant Experience Server 0.9.x](http://www.getvariant.com/resources/docs/0-9/experience-server/user-guide/) 
* Java 8 or later.

This __Variant Demo Application__ demonstrates instrumentation of two simple experience variations: an experiment (A/B test) and a concurrent feature toggle on a Java servlet Web application. This demonstration will help you
* Download, install and deploy Variant Experience Server on your local system;
* Clone and deploy this demo application on your local system;
* Step through the instrumented variations;
* Understand the instrumentation details of the demo.

Note, that this demo application is built with the popular [Pet Clinic webapp](https://github.com/spring-projects/spring-petclinic), available from the Sprinig MVC project. We are using it to demonstrate Variant's [Java client](http://getvariant.com/resources/docs/0-9/clients/variant-java-client) as well as the [servlet adapter for Variant Java client](https://github.com/getvariant/variant-java-servlet-adapter). If your application does not run in a servlet container, much of this demonstration will still be applicable.

## 1. Start Variant Server

• [Download and install](https://www.getvariant.com/resources/docs/0-9/experience-server/reference/#section-1) Variant Experience Server.

• Start Variant server:
```
% /path/to/server/bin/variant.sh start
```

If all went well, the server console output should look something like this:
```
[info] 19:10:12.717 c.v.c.c.ConfigLoader - Found  config resource [/variant.conf] as [/private/tmp/demo/variant-server-0.9.3/conf/variant.conf]
[info] 19:10:14.091 c.v.s.s.SchemaDeployerFileSystem - Mounted schemata directory [/private/tmp/demo/variant-server-0.9.3/schemata]
[info] 19:10:14.092 c.v.s.s.SchemaDeployerFileSystem - Deploying schema from file [/private/tmp/demo/variant-server-0.9.3/schemata/petclinic.schema]
[info] 19:10:14.285 c.v.s.s.ServerFlusherService - Registered event logger [com.variant.server.api.EventFlusherAppLogger] for schema [petclinic]
[info] 19:10:14.312 c.v.s.s.SchemaDeployerFileSystem - Deployed schema [petclinic] ID [38EFB1D4B56FCA01], from [petclinic.schema]:
   NewOwnerTest:[outOfTheBox (control), tosCheckbox, tosAndMailCheckbox] (ON)
[info] 19:10:14.317 c.v.s.b.VariantServerImpl - [431] Variant Experiment Server release 0.9.3 bootstrapped on :5377/variant in 00:01.247
```

Note, that Variant server comes pre-configured to run the demo application out-of-the-box. The `/schemata` directory contains the demo experiment schema file `petclinic.schema`, and the `/ext` directory contains the `server-extensions-demo-<release>.jar` file, containing the user hooks, used this demonstration.

## 2. Deploy the Demo Appliction

• Clone This Repository:
```
% git clone https://github.com/getvariant/variant-java-demo.git
```
• Change directory to `variant-java-demo`
```
% cd variant-java-demo
```
• Install Maven Dependencies

Variant Demo application is built on top of the [servlet adapter](https://github.com/getvariant/variant-java-servlet-adapter). It is included in this repository's `/lib` directory and must be installed in your local Maven repository: 

```
% mvn install:install-file -Dfile=lib/variant-java-client-0.9.3.jar -DgroupId=com.variant -DartifactId=variant-java-client -Dversion=0.9.3 -Dpackaging=jar

% mvn install:install-file -Dfile=lib/variant-core-0.9.3.jar -DgroupId=com.variant -DartifactId=variant-core -Dversion=0.9.3 -Dpackaging=jar

% mvn install:install-file -Dfile=lib/variant-java-client-servlet-adapter-0.9.3.jar -DgroupId=com.variant -DartifactId=variant-java-client-servlet-adapter -Dversion=0.9.3 -Dpackaging=jar
```

• Start the demo application:
```
% mvn tomcat7:run
```
If all went well, you will see the following console output:
```
INFO  2017-08-03 16:46:42 VariantConfigLoader - Found config resource [/variant.conf] as [/private/tmp/demo/variant-java-servlet-adapter/servlet-adapter-demo/target/classes/variant.conf]
INFO  2017-08-03 16:46:43 VariantFilter - Connected to schema [petclinic]
```
The demo application is accessible at <span class="variant-code">http://localhost:9966/petclinic/</span>.

• Optionally, configure a custom Variant server URL

Out-of-the-box, the demo application looks for Variant server at the default URL `http://localhost:5377/variant`. If your server is running elsewhere, you must update the Variant client configuration file [/src/main/resources/variant.conf](https://github.com/getvariant/variant-java-demo/blob/master/src/main/resources/variant.conf) by setting the `server.url` property. Restart Variant server to have the new value take effect.


## 3. Run the Demo Experiment

The demo experiment is instrumented on the `New Owner` page. You navigate to it from the home page by clicking "Find Owners", followed by "New Owner". The original page, that the demo application comes with, looks like this:

| <img src="http://www.getvariant.com/wp-content/uploads/2015/11/outOfTheBox-1024x892.png" alt="outOfTheBox" width="610" height="531" /> |
| ------------- |
| __Fig. 1. The orignal New Owner page.__ | 

<br>

The demo experiment introduces two variants of this page called `tosCheckBox` and `tos&mailCheckbox`, as illustrated below.

| <img src="http://www.getvariant.com/wp-content/uploads/2015/11/tosCheckbox-1024x954.png" alt="tosCheckbox" width="610" height="568" /> | 
| ------------- | 
| __Fig. 2. The `tosCheckBox` variant adds the terms of service check box.__ |

<br>

| <img src="http://www.getvariant.com/wp-content/uploads/2015/11/tosmailCheckbox-1024x1000.png" alt="tos&mailCheckbox" width="610" height="596" /> | 
| ------------- |
| __Fig. 3. The `tos&mailCheckbox` variant adds the email list<br>opt-in check box in addition to the ToS checkbox.__ | 
 
<br>

The metric we're after in this experiment is the next page conversion rate, i.e. the ratio of visitors who completed the signup form and successfully navigated to the next page to all those who came to the New Owner page. 

In order to demonstrate the power of [Variant Server's Extension API](http://getvariant.com/resources/docs/0-9/experience-server/user-guide/#section-8), the demo application is configured with two lifecycle hooks: [`SafariDisqualifier`](https://github.com/getvariant/variant-server-extapi/blob/master/src/main/java/com/variant/server/ext/demo/SafariDisqualHook.java) and [`ChromeTargeter`](https://github.com/getvariant/variant-server-extapi/blob/master/src/main/java/com/variant/server/ext/demo/ChromeTargetingHook.java). The former disqualifies all traffic coming from a Safari browser, and the latter targets all traffic coming from a Chrome browser to the control experience. Obviously, both of these lifecycle hooks are contrived and only serve to illustrate the power of the server-side ExtAPI.

If you visit the Petclinic site using a Safari browser, your experience will be equivalent to there being no experiment at all: you will always see the existing experience and your visit to the New Owner page will not trigger Variant events. Similarly, if you use a Chrome browser, you will always see the existing experience, but when you touch instrumented pages Variant will generate and log experiment related events. Although this behavior may seem contrived, it demonstrates how easy it is to inject experiment qualification or targeting semantics into your Variant server.

If you navigate to the New Owner page in any other browser, you may land on either of the three variants. Once there, you will notice the `STATE-VISIT` event in the server log (after a short delay due to the asynchronous nature of the server event writer):

```
[info] c.v.s.e.EventFlusherAppLogger - {event_name:'$STATE_VISIT', created_on:'1500325855912', event_value:'newOwner', session_id:'55D817210864DB27', event_experiences:[{test_name:'NewOwnerTest', experience_name:'tosCheckbox', is_control:false}], event_params:[{key:'PATH', value:'/owners/new/variant/newOwnerTest.tosCheckbox'}, {key:'$REQ_STATUS', value:'OK'}]}
[info] c.v.s.e.EventWriter$FlusherThread - Flushed 1 event(s) in 00:00:00.002
```

`STATE-VISIT` event is automatically generated by Variant each time a user session visits a web page that is instrumented by a live Variant experiment. 

Out-of-the-box, Variant server's event writer is configured to flush event to the server log file. In real life, you will likely use an event flusher that persists Variant events to some more manageable persistent storage. Variant server comes with event flushers for H2 and PostgreSQL relational databases, which you can [configure to match your environment](http://getvariant.com/resources/docs/0-9/experience-server/reference/#section-4.3).

If you happen to return to the New Owner page, you will always see the same experience &mdash; the feature known as targeting stability. The Pet Clinic demo application comes pre-configured with the HTTP cookie based implementation. If you want to let Variant re-target your session, simply remove both `variant-target` and `variant-ssnid` cookies from your browser.

## 4. Discussion

Any online experiment starts with the implementation of variant experiences that will be compared to the existing code path. To accomplish this, we did the following:

1. Created controller mappings in the class <a href="https://github.com/getvariant/variant-java-servlet-adapter/blob/master/servlet-adapter-demo/src/main/java/org/springframework/samples/petclinic/web/OwnerController.java#L79-L117" target="_blank">OwnerController.java</a> for the new resource paths `/owners/new/variant/newOwnerTest.tosCheckbox` and `/owners/new/variant/newOwnerTest.tosAndMailCheckbox` — the entry points into the new experiences. Whenever Variant targets a session for a non-control variant of the `newOwner` page, it will forward the current HTTP request to that path. Otherwise, the request will proceed to the control page at the originally requested path `/owners/new/`.

2. Created two new JSP pages [`createOrUpdateOwnerForm__newOwnerTest.tosCheckbox.jsp`](https://github.com/getvariant/variant-java-servlet-adapter/blob/master/servlet-adapter-demo/src/main/webapp/WEB-INF/jsp/owners/createOrUpdateOwnerForm__newOwnerTest.tosCheckbox.jsp) and  [`createOrUpdateOwnerForm__newOwnerTest.tosAndMailCheckbox.jsp`](https://github.com/getvariant/variant-java-servlet-adapter/blob/master/servlet-adapter-demo/src/main/webapp/WEB-INF/jsp/owners/createOrUpdateOwnerForm__newOwnerTest.tosAndMailCheckbox.jsp), implementing the two new variants of the new owner page.

3. Created the experiment schema. 
```
//
// Variant Java client + Servlet adapter demo application.
// Demonstrates instrumentation of a basic Variant experiment.
// See https://github.com/getvariant/variant-java-servlet-adapter/tree/master/servlet-adapter-demo
// for details.
//
// Copyright © 2015-2017 Variant, Inc. All Rights Reserved.

{
   'meta':{
      'name':'petclinic',
      'comment':'Experiment schema for the Pet Clinic demo application'
   },
   'states':[                                                
     { 
       // The New Owner page used to add owner at /petclinic/owners/new 
       'name':'newOwner',
       'parameters': [
            {
               'name':'path',
               'value':'/petclinic/owners/new'
            }
        ]
     },                                                    
     {  
       // The Owner Detail page. Note that owner ID is in the path,
        // so we have to use regular expression to match.
       'name':'ownerDetail',
       'parameters': [
            {
               'name':'path',
               'value':'/petclinic/owners/~\\d+/'
            }
        ]
     }                                                     
   ],                                                        
   'tests':[                                                 
      {                                                      
         'name':'NewOwnerTest',
         'isOn': true,                                     
         'experiences':[                                     
            {                                                
               'name':'outOfTheBox',                                   
               'weight':1,                                  
               'isControl':true                              
            },                                               
            {                                                
               'name':'tosCheckbox',                                   
               'weight':1                                   
            },                                               
            {                                                
               'name':'tosAndMailCheckbox',                                   
               'weight':1                                   
            }                                               
         ],                                                  
         'onStates':[                                         
            {                                                
               'stateRef':'newOwner',                    
               'variants':[                                  
                  {                                          
                     'experienceRef': 'tosCheckbox',
                     'parameters': [
                        {
                           'name':'path',
                           'value':'/owners/new/variant/newOwnerTest.tosCheckbox'
                        }
                     ]
                  },                                         
                  {                                          
                     'experienceRef': 'tosAndMailCheckbox',                   
                     'parameters': [
                        {
                           'name':'path',
                           'value':'/owners/new/variant/newOwnerTest.tosAndMailCheckbox'
                        }
                     ]
                  }                                          
               ]                                             
            },
            {                                                
               'stateRef':'ownerDetail',                            
               'isNonvariant': true
            }                                                
         ],
         'hooks':[
            {
               // Disqualifies all Safari traffic.
               'name':'SafariDisqualifier',
               'class':'com.variant.server.ext.demo.SafariDisqualHook'
            },
            {
               // Assigns all Chrome traffic to the control experience
               'name':'ChromeTargeter',
               'class':'com.variant.server.ext.demo.ChromeTargetingHook'
            }
         ]
      }                                                     
   ]                                                         
}                         
      

```
Note, that Variant server comes out-of-the-boxwith this schema already in the `schemata` directory.

The two states (lines 14-30) correspond to the two consecutive pages in the experiment: <span class="variant-code">newOwner</span> and <span class="variant-code">ownerDetail</span>. The sole experiment <span class="variant-code">NewOwnerTest</span> has three experiences (lines 35-49) with equal weights, i.e. roughly equal number of users sessions will be targeted to each of the experiences. The test is instrumented on both pages, although the <span class="variant-code">ownerDetail</span> page is defined as non-variant (lines 68-71), which means that visitors will see the same page regardless of the targeted experience. The <span class="variant-code">newOwner</span> page, however, has two variants: one for each non-control experience (lines 53-66).

4. Created [`PetclinicVariantFilter`](https://github.com/getvariant/variant-java-servlet-adapter/blob/master/servlet-adapter-demo/src/main/java/com/variant/client/servlet/demo/PetclinicVariantFilter.java) and configured it in the Petclinic applciation's [`web.xml`](https://github.com/getvariant/variant-java-servlet-adapter/blob/master/servlet-adapter-demo/src/main/webapp/WEB-INF/web.xml#L124-L137) file. In general, servlet filter is the instrumentation mechanism behind the servlet adapter. Here, we extend the base [`VariantFilter`](https://github.com/getvariant/variant-java-servlet-adapter/blob/master/servlet-adapter/src/main/java/com/variant/client/servlet/VariantFilter.java) class with additional semantics: whenever the base `VariantFilter` obtains a Variant session, the User-Agent header from the incoming request is saved as a session attribute. This will be used by the server side user hooks in order to disqualify or target user sessions based on what Web browser they are coming from.

5. Created [FirefoxDisqualifier](https://github.com/getvariant/variant-server-extapi/blob/master/server-extapi-demo/src/main/java/com/variant/server/ext/demo/FirefoxDisqualHook.java) and [ChromeTargeter](https://github.com/getvariant/variant-server-extapi/blob/master/server-extapi-demo/src/main/java/com/variant/server/ext/demo/ChromeTargetingHook.java) user hooks. Out-of-the-box, Variant server comes with the `/ext/server-extensions-demo-0.7.1.jar` JAR file, containing class files for these hooks. See [Variant Experiment Server Reference](http://www.getvariant.com/docs/0-7/experiment-server/reference/#section-4) for details on how to develop for the server extensions API. 

6. Instrumented the submit button on the `newOwner` page to send a custom `CLICK` event to the server when the button is pressed by editing the [`staticFiles.jsp`](https://github.com/getvariant/variant-java-servlet-adapter/blob/master/servlet-adapter-demo/src/main/webapp/WEB-INF/jsp/fragments/staticFiles.jsp#L32-L68) file.




Updated on 19 July 2017.
