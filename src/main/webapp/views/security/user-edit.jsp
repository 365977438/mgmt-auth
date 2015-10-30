<script src="./assets/js/jquery.validate.js"></script>
<script src="./assets/js/jquery.validate-zh-CN.js"></script>

<#import "/spring.ftl" as spring />

<script type="text/javascript">
jQuery(function($) {
	$('#user-edit-form').validate({
		errorElement: 'div',
		errorClass: 'help-block',
		focusInvalid: false,
		ignore: "",
		rules: {
			username: {
				required: true,
				//http://jqueryvalidation.org/remote-method
				remote: {
			        url: sys.basePath + "/sys_user/checkUsername.do",
			        type: "post",
			        data: {
			          id: function() {
			        	  return $('#id').val();
			          },
			          username: function() {
			            return $("#username").val();
			          }
			        }
			      }
			},
			authenticator: {
				required: true,
				minlength: 6
			},
			lastName: {
				required: true
			},
			firstName: {
				required: true
			},
			email: {
				required: true,
				email: true
			},
			mobile: {
				required: true,
				digits: true,
				minlength: 11,
				maxlength: 11
			},
			departmentId: {
				required: true
			}
		},
	
		messages: {
			username: {
				required: "请输入用户名."
			},
			authenticator: {
				required: "请输入密码.",
				minlength: "密码长度至少6位."
			},
			mobile: {
				minlength: "手机号码为11位",
				maxlength: "手机号码为11位"
			}
		},
	
		highlight: function (e) {
			$(e).closest('.form-group').removeClass('has-info').addClass('has-error');
		},
	
		success: function (e) {
			$(e).closest('.form-group').removeClass('has-error');//.addClass('has-info');
			$(e).remove();
		}
	});
});

var user_edit = {};

user_edit.save = function() {
	if (!$('#user-edit-form').valid()) {
		return;
	}
	var obj = sys.form2Object('#user-edit-form');
	$.ajax({
		url: $('#user-edit-form').attr('action'),
		type: "POST",
		dataType: "json",
		data: {"object": JSON.stringify(obj)},
		success:function(response,st, xhr) {
			if(typeof(response.success)=="undefined"){
				sys.alertInfo("无结果返回/登录超时或未登录", 'danger');
				return;
			}
			if (response.success == true) {
				sys.alertInfo(response.msg, 'success');
				sys.backInTab('sys_user_index');
			}else {
				console.error(response.msg);
				sys.alertInfo(response.msg, 'danger');
			}
		},
		error:function(xhr,type,msg){
			console.error(msg);
			sys.alertInfo(msg, 'danger');
		}
	});
};

user_edit.back = function() {
	sys.backInTab('sys_user_index');
};
</script>
<form class="form-horizontal" id="user-edit-form" method="post" action="${ctx.getContextPath()}/sys_user/save.do">
	<input type="hidden" name="id" id="id" value="${(user.id)!}"/>
	<input type="hidden" name="oldAuthenticator" id="oldAuthenticator" value="${(oldAuthenticator)!}" />
	
	<div class="form-group has-info">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="username">用户名:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="username" id="username" value="${(user.username)!}"
					class="col-xs-12 col-sm-5" />
			</div>
		</div>
	</div>

	<div class="space-2"></div>

	<div class="form-group has-info">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="authenticator">密码:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="password" name="authenticator" id="authenticator" value="${(user.authenticator)!}"
					class="col-xs-12 col-sm-5" />
			</div>
		</div>
	</div>

	<div class="space-2"></div>

	<div class="form-group has-info">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right">姓名:</label>

		<div class="col-xs-12 col-sm-9">
			<span>
				<input type="text" name="lastName" id="lastName" placeholder="姓" value="${(user.lastName)!}"
					class="col-xs-6 col-sm-2" />
				<input type="text" name="firstName" id="firstName" placeholder="名字" value="${(user.firstName)!}"
					class="col-xs-6 col-sm-3" />
			</span>
		</div>
	</div>
	
	<div class="space-2"></div>

	<div class="form-group has-info">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right">邮箱地址:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="email" id="email" value="${(user.email)!}"
					class="col-xs-12 col-sm-5" />
			</div>
		</div>
	</div>
	
	<div class="space-2"></div>

	<div class="form-group has-info">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right">手机号码:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="mobile" id="mobile" value="${(user.mobile)!}"
					class="col-xs-12 col-sm-5" />
			</div>
		</div>
	</div>
	
	<div class="space-2"></div>

	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right">固定电话:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="telephone" id="telephone" value="${(user.telephone)!}"
					class="col-xs-12 col-sm-5" />
			</div>
		</div>
	</div>
	
	<div class="space-2"></div>

	<div class="form-group has-info">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right">部门:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<!--  input type="text" name="departmentId" id="departmentId" value="${(user.departmentId)!}"
					class="col-xs-12 col-sm-2" /-->
  					<@spring.formSingleSelect "user.departmentId", deptOptions, ""/>
			</div>
		</div>
	</div>
	
	<div class="space-2"></div>

	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right">办公地点:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="officeLocation" id="officeLocation" value="${(user.officeLocation)!}"
					class="col-xs-12 col-sm-5" />
			</div>
		</div>
	</div>
	
	<div class="space-2"></div>
	
	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="password2">可否可用:</label>

		<div class="col-xs-12 col-sm-2">
			<div class="clearfix">
				<input type="checkbox" class="ace" name="status" id="status" <#if user??&&user.status??&&user.status>checked</#if>/>
				<span class="lbl"></span>
			</div>
		</div>
	</div>
	
	<div class="form-group">
		<div class="col-xs-12 col-sm-9 center">
			<div class="clearfix">
				<button type="button" class="btn btn-info" onclick="javascript:user_edit.save();">
   					<i class="ace-icon fa fa-floppy-o"></i>保存
 				</button>
 				<button type="button" class="btn btn-default" onclick="javascript:user_edit.back();">
   					<i class="ace-icon fa fa-times red2"></i>取消
 				</button>
			</div>
		</div>
	</div>
	<div class="hr hr-dotted"></div>
</form>