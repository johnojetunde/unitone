<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!-- Include the lid -->
<%@ include file="../includes/lid.jsp" %>      

<!-- Include the header -->
<%@ include file="../includes/header.jsp" %>

<%@ include file="../includes/sidebar.jsp" %>   
<script>
         
         var mainApp = angular.module("agentBox",['ngwidgets']);
         
         console.log("************ App initialized ************");
        
         mainApp.factory("fetchMessages",["$http","$q",function($http,$q)
             {
                
                return { 
                  fetch : function(id){
                             var deferred = $q.defer();
                             $http({
                               method : "GET",
                               url : "${pageContext.request.contextPath}/Message?action=message_thread&customerId="+id,
                               
                               }
                             ).success(function(res){
                                 deferred.resolve(res);
                             }).error(function(errMsg,code){
                                 deferred.reject(errMsg);
                             });
                             return deferred.promise;
                        }
                }
                 
                 
             }]);
         
         mainApp.controller("agentMailCtrl",function($scope,fetchMessages){
             
             
             $scope.customers = [];
             console.log("*************************** Entered Controller ************************");
             
             <c:forEach items="${customers}" var="customer">
                     
                     var row = {};
                     row["id"] = "${customer.get('id')}";
                     row["name"] = "${customer.get('fullname')}";
                     row["photo"] = "${customerImageAccessDir}" + "/" + "${customer.get('photoPath')}";
                     
                     $scope.customers.push(row);
             </c:forEach>
                 
             
             $scope.getCustomerMessage = function(event){
                 var id = event.args.item.value;
                 
                 console.log("Customer selected : " + event.args.item.label + ", Id : " + id)
                 
                 var messageJson = fetchMessages.fetch(id)
                         .then(function(data){
                                if(data == "SESSION_EXPIRED"){
                                    location.reload(true);
                                }
                                $scope.showMessageThread(data);
                          },function(error){
                          })
                          
             };
             
             $scope.msg = "";
             
             $scope.showMessageThread = function(messages){
                 
                 var messages = JSON.parse(JSON.stringify(messages));
                 var fullThread = "";
                 var userId = "${id}";
                 
                 for(var k in messages){
                     
                     var singleThread = "";
                     
                     var message = messages[k];
                     var replies = messages[k].replies;
                     
                     for(var j in replies){
                         
                         if(userId == replies[j].userId && replies[j].userType == 2){
                             var subject = "<b><u>RE: </u>" + replies[j].subject +  "</b>&nbsp <i class='fa fa-arrow-right'></i>";
                         }
                         else{
                            var subject = "<b><u>RE: </u>" + replies[j].subject +  "</b> &nbsp<a href='${pageContext.request.contextPath}/Message?action=reply&id=" + replies[j].id + "'>Reply</a>";
                         }
                         var body = replies[j].body;
                         var id = replies[j].id;
                         var date = replies[j].date + "<br /><br />"; 
                         
                         singleThread += subject + body + date;
                     }
                         if(userId == message.userId && message.userType == 2){
                            var subject = "<b>" + message.subject +  "</b>&nbsp <i class='fa fa-arrow-right'></i>";
                         }
                         else{
                            var subject = "<b>" + message.subject +  "</b>&nbsp<a href='${pageContext.request.contextPath}/Message?action=reply&id=" + message.id + "'>Reply</a>";
                         }
                         var body = message.body;
                         var id = message.id;
                         var date = message.date + "<br />"; 
                         
                         singleThread += subject + body + date + "<hr />";
                         
                         fullThread += singleThread;
                 }
                 
                 console.log(fullThread);
                 $("#message-box").html(fullThread);
               
             };
             
             $scope.settings = {
               
               filterable: true, selectedIndex: 0, source: $scope.customers,  height: 450, width : "100%",
               displayMember: 'name',
               valueMember: 'id',
               searchMode : 'containsignorecase',
                renderer: function (index, label, value) {
                    
                    
                    var img = '<img height="50" width="50" src="' + $scope.customers[index].photo + '"/>';
                    var table = '<table style="min-width: 130px;"><tr><td style="width: 80px;">' + img + '</td><td>' + label + '</td></tr></table>';
                    return table;
                }
               
           };
             
         });
 
         
          
 </script> 

      <!-- Content Wrapper. Contains page content -->
      <div class="content-wrapper" ng-app="agentBox">

         
        <!-- Content Header (Page header) -->
        <section class="content-header">
          <h1>
            Agent MailBox
          </h1>
        </section>

        <!-- Main content -->
        <section class="content" ng-controller="agentMailCtrl">
            <div class="row">
                
                <div class="col-md-4">
                    <div class="panel panel-primary">
                        <div class="panel-heading">
                            <h3 class="panel-title">Customers</h3>
                        </div>
                        <div class="panel-body">
                            <ngx-list-box style="border: none;" ngx-on-select="getCustomerMessage(event)" ngx-settings="settings">
                            </ngx-list-box>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-8">
                    
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h3 class="panel-title"></h3>
                        </div>
                        <div class="panel-body" id="message-box" style="height:450px;overflow-y: auto">
                        </div>
                    </div>
                    
                </div>
                
            </div>  
        </section><!-- /.content -->
      </div><!-- /.content-wrapper -->
      

<!-- Include the footer -->
<%@ include file="../includes/footer.jsp" %>      


<!-- Include the control sidebar -->
<%--<%@ include file="../includes/control-sidebar.jsp" %>--%>      
      
<!-- Include the bottom -->
<%@ include file="../includes/bottom.jsp" %>


  
