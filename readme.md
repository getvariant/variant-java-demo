![Variant Logo](http://www.getvariant.com/wp-content/uploads/2016/07/VariantLogoSquare-100.png)

# Variant Experience Server Demo Application
#### Requires: 
* [Variant Java Client 0.10](https://www.getvariant.com/resources/docs/0-10/clients/variant-java-client/)
* [Variant AIM Server 0.10](http://www.getvariant.com/resources/docs/0-10/application-iteration-server/user-guide/) 
* Java 8 or later.

This __Variant Demo Application__ demonstrates instrumentation of two simple experience variations: an experiment (A/B test) and a concurrent feature flag in a Java servlet Web application. This demonstration will help you
* Download, install and deploy Variant AIM Server on your local system;
* Clone and deploy this demo application on your local system;
* Step through the instrumented variations;
* Examine the trace events prodiced by the two variations;
* Understand the instrumentation details of the two variations.

Note, that this demo application is built on top the popular [Pet Clinic webapp](https://github.com/spring-projects/spring-petclinic), available from the Sprinig MVC project. We are using it to demonstrate Variant's [Java client](http://getvariant.com/resources/docs/0-10/clients/variant-java-client) as well as the [servlet adapter for Variant Java client](https://github.com/getvariant/variant-java-servlet-adapter). If your application does not run in a servlet container, or in fact, is not even running on a Java virtual machine, much of this demonstration will still be applicable.

## 1. Start Variant Server

__∎ [Download and install](https://www.getvariant.com/resources/docs/0-10/application-iteration-server/reference/#section-1) Variant AIM Server__

__∎ Start Variant Server__
```
$ /path/to/server/bin/variant.sh start
```

If all went well, the server console output should look something like this:
```
[info] 15:38:18.475 c.v.s.b.ConfigLoader - Found  config resource [/variant.conf] as [/private/tmp/server/variant-server-0.10.0/conf/variant.conf]
[info] 15:38:20.275 c.v.s.s.SchemaDeployerFileSystem - Mounted schemata directory [/private/tmp/server/variant-server-0.10.0/schemata]
[info] 15:38:20.276 c.v.s.s.SchemaDeployerFileSystem - [432] No schemata found in [/private/tmp/server/variant-server-0.10.0/schemata]
[info] 15:38:20.278 c.v.s.b.VariantServerImpl - [433] Variant AIM Server release 0.10.0 bootstrapped on port [5377] in 3.063s
```

## 2. Deploy the Demo Appliction

__∎ Clone This Repository__
```
$ git clone https://github.com/getvariant/variant-java-demo.git
```
__∎ Change Directory to `variant-java-demo`__
```
$ cd variant-java-demo
```

__∎ Copy the Variation Schema to the Server's `schemata/` Directory:__
```
$ cp petclinic.schema /path/to/server/schemata
```

If all went well, the server console output should look something like this:
```
[info] 15:43:20.279 c.v.s.s.SchemaDeployerFileSystem - [421] Deploying schema from file [/private/tmp/server/variant-server-0.10.0/schemata/petclinic.schema]
[info] 15:43:20.447 c.v.s.s.ServerFlusherService - Registered event flusher [com.variant.extapi.std.flush.TraceEventFlusherCsv] for schema [petclinic]
[info] 15:43:20.468 c.v.s.s.Schemata - [422] Deployed schema [petclinic] from file [petclinic.schema]
Name: petclinic
   Comment: Optional[Variant schema for the Pet Clinic demo application]
   States: 2
   Variations: 2
```

__∎ Start the Demo Application:__
```
% mvn tomcat7:run
```
If all went well, you will see the following at the bottom of the console output:
```
INFO: Starting Servlet Engine: Apache Tomcat/7.0.47
INFO  2019-07-01 15:53:12 VariantContext - Connected to Variant URL [variant://localhost:5377/petclinic]
```
The demo application is now accessible at <span class="variant-code">http://localhost:9966/petclinic/</span>.

__∎ Optionally, Configure a Custom Variant Server URL__

By default, the demo application looks for Variant server at the default URL `http://localhost:5377`. If your server is running elsewhere, you must update [VariantContext.java](https://github.com/getvariant/variant-java-demo/blob/0310112c63ae1922b3b75622d000421956301c4a/src/main/java/com/variant/client/servlet/demo/VariantContext.java#L20) and restart the demo application.

## 3. Run the Demo

### 3.1 User Experiences

The demo consists of two variations:

__The feature toggle `VetsHourlyRateFeature`__ exposes an early release of a the new feature, which adds the _Hourly Rate_ column to the `Veterinarians` page below.

<img src="https://github.com/getvariant/variant-java-demo/blob/767b758b2e145dca688bbc65e521e5ac804f4fb7/docs/img/Fig-1-all-control.png">

__The experiment `ScheduleVisitTest`__ validates another new feature, designed to improve new appointment bookings by displaying new _Availability_ column on the same same `Veterinarians` page.

Since the  `Veterinarians` page is shared by both variations, it can have 4 variants:

<table>
  <tr>
    <th>VetsHourlyRate
       Feature</th>
    <th colspan="2">ScheduleVisitTest</th>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Control</td>
    <td>With Availability Column</td>
  </tr>
  <tr>
    <td>Control</td>
    <td>
       <img src="https://github.com/getvariant/variant-java-demo/blob/master/docs/img/Fig-1-all-control.png">
       Existing code path.
     </td>
    <td>
        <img src="https://github.com/getvariant/variant-java-demo/blob/master/docs/img/Fig-1-with-appt-link.png">
       With availability column. (Proper state variant).
     </td>
  </tr>
  <tr>
    <td>With Hourly Rate Column</td>
    <td>
       <img src="https://github.com/getvariant/variant-java-demo/blob/master/docs/img/Fig-1-with-hourly-rate.png">
       With hourly rate column. (Proper state variant).
     </td>
    <td>
       <img src="https://github.com/getvariant/variant-java-demo/blob/master/docs/img/Fig-1-hybrid.png">
       With both columns. (Hybrid state variant).
     </td>
  </tr>
</table>

If a session is targeted for control experiences in both variations, it is served the existing `Veterinarians` page with two columns. If a session is targeted for a variant experience in either variation, and to control in the other, it sees either of the two _proper_ variants of the `Veterinarians` page with one extra column. Finally, if a session is targeted for variant experiences in _both_ variations, it is served the _hybrid_ variant of the `Veterinarians` page with two extra columns. 

Hybrid state variants are optional in Variant: unless explicitly configured in the schema, concurrent variations are treated as _disjoint_, i.e. Variant server will not target any sessions to variant experiences in both variations. However, in this demo, the more complex _conjoint_ concurrency model is demonstrated. It supports hybrid state variants, when both variations are targeted to the variant experience. This is explained in detain in a subsequent section.

When you first navigate to the `Veterinarians` page, Variant server targets your session randomly in both variations. This targeting is _durable_, so reloading the page won't change it. If you want to make Variant to re-target, get a new private browser window or remove all variant-related cookies. (Note that some browsers share cookies between private windows, so be sure that there are no other private windows open.) You may also vary the probability weights by editing the `petclinic.schema` file in the server's `schemata` directory.

If your session happened to be targeted to the variant experience in the `ScheduleVisitTest` and you see the _Schedule visit_ link, clicking it will navigate to the experimental version of the `New Visit`page, containing the vet's name:

<table>
  <tr>
    <th colspan="2">ScheduleVisitTest</th>
  </tr>
  <tr>
    <td>Control</td>
    <td>With Availability Column</td>
  </tr>
  <tr>
    <td>
       <img src="https://github.com/getvariant/variant-java-demo/blob/9a1f7df67fd559a6c4b83fab9c8567d09e678246/docs/img/Fig-2-control.png">
       Existing code path.
     </td>
    <td>
       <img src="https://github.com/getvariant/variant-java-demo/blob/9a1f7df67fd559a6c4b83fab9c8567d09e678246/docs/img/Fig-2-with-appt-link.png">
       With availability column.
     </td>
  </tr>
</table>

### 3.2 Event Tracing

The variation schema for this demo does not specify a tracing event flusher, deferring to the default [TraceEventFlusherServerLog](https://getvariant.github.io/variant-extapi-standard/com/variant/extapi/std/flush/TraceEventFlusherServerLog.html), which appends trace events to the server loger file `log/variant.log`:  

```
[info] 20:03:19.431 c.v.s.e.EventWriter$FlusherThread - Flushed 1 event(s) in 00:00:00.000
[info] 20:03:40.444 c.v.s.a.EventFlusherAppLogger - {event_name:'$STATE_VISIT', created_on:'1538967820228', session_id:'11BAEABC9F08B6F8', event_experiences:[{test_name:'ScheduleVisitTest', experience_name:'noLink', is_control:true}], event_attributes:[{key:'$STATE', value:'vets'}, {key:'HTTP_STATUS', value:'200'}, {key:'$STATUS', value:'Committed'}]}
```

The `STATE-VISIT` event is automatically triggered by Variant each time a user session visits an instrumented Web page. Note the delay between the time your session lands on an instrumented page and when the event is flushed to the log. This is due to the asynchronous nature of Variant's event writer. You can reduce the lag by changing the value of the `event.writer.max.delay` server configuration parameter in the `conf/variant.conf` file. 

You can also [configure a different trace event flusher](https://www.getvariant.com/resources/docs/0-10/application-iteration-server/reference/#section-4.4.2) to utilize a persistence mechanism of your choice. 

Trace events provide the basis for analyzing variations. Features can be programmatically disabled if trace events indicate an unexpected failure, and experiments can be analyzed for target metrics and statistical significance.

## 4. Instrumentation

The variation schema used by this demo application can be found in this repository's [`petclinic.schema`](https://github.com/getvariant/variant-java-demo/blob/master/petclinic.schema). The two states `vets``newVisit`correspond to the `Veterinarians` page and the `New Visit` page.

The [`VetsHourlyRateFeature`](https://github.com/getvariant/variant-java-demo/blob/master/petclinic.schema#L27-L43) variation is instrumented on the single `Veterinarians` page and has two experiences `existing` (control) and `rateColumn` with randomized weights 3:1 in favor of the variant. 


The [`ScheduleVisitTest`](https://github.com/getvariant/variant-java-demo/blob/master/petclinic.schema#L50-L75) variation is instrumented on two pages, starting on the `Veterinarians` page and ending on the `New Visit` page. Note the [`conjointVariationsRefs`](https://github.com/getvariant/variant-java-demo/blob/master/petclinic.schema#L52) specification, declaring the conjoint concurrence between the two variations. This specification tells Variant that `ScheduleVisitTest` and `VetsHourlyReateFeature` are conjointly concurrent, i.e. that it's okay for Variant server to target a session for these two variations completely independently. Note also the [`UserQualifyingHook`](https://github.com/getvariant/variant-java-demo/blob/master/petclinic.schema#L69-L73) lifecycle event hook which disqualifies blacklisted users from this feature. This demonstrates the power of the server-side ExtAPI, which enables such highly reusable components which operate on the operational data but are entirely outside of the host application's code base.

## 5 Implementations

The `VetsHourlyRateFeature` variation does not specify any state parameter overrides, so if the session was targeted for the control experience in the covariant `ScheduleVisitTest` variation, `VariantFilter` lets the HTTP request fall through. Both experiences will proceed though the existing code path up until [`vets.jsp`](https://github.com/getvariant/variant-java-demo/blob/e783434ae9c5166d7c19e8ee6642714e12c6418d/src/main/webapp/WEB-INF/jsp/vets/vetList.jsp#L34-L54), where the new _Hourly Rate_ column is optionally displayed, depending on the live experience in effect. This type of experience instrumentation, where the code bifurcates as late in the code path as possible, is referred to as _lazy instrumentation_.

Alternatively, the `ScheduleVisitTest` variation makes use of the state parameter overrides. If a session is targeted to the `withLink` experience, `VariantFilter` forwards it to the new `/vets__ScheduleVisit_withLink.html` path, which is [mapped](https://github.com/getvariant/variant-java-demo/blob/e783434ae9c5166d7c19e8ee6642714e12c6418d/src/main/java/org/springframework/samples/petclinic/web/VetController.java#L54-L63) to the [`vets/vetList__ScheduleVisit_withLink.jsp`](https://github.com/getvariant/variant-java-demo/blob/e783434ae9c5166d7c19e8ee6642714e12c6418d/src/main/webapp/WEB-INF/jsp/vets/vetList__ScheduleVisit_withLink.jsp), which is a copy of the existing `vets/vetList.jsp` plus the implementation of the new _Availability_ column. This type of experience instrumentation, where the code bifurcates as early as possible, is referred to as _eager instrumentation_.

Updated for 0.9.3 on 8 October 2018.
