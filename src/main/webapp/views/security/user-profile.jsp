<script type="text/javascript">
var user_profile = {};

user_profile.save = function() {
	var obj = sys.form2Object('#user-profile-form');
	$.ajax({
		url: $('#user-profile-form').attr('action'),
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
</script>
<div id="user-profile-3" class="user-profile row">
	<div class="col-sm-offset-1 col-sm-12">
		<form class="form-horizontal" id="user-profile-form" method="post" action="${ctx.getContextPath()}/sys_user/save.do">
			<input type="hidden" name="id" id="id" value="${(user.id)!}" />
			<input type="hidden" name="status" id="status" value="${user.status?c}" />
			<input type="hidden" name="departmentId" id="departmentId" value="${(user.departmentId)!}" />
			<input type="hidden" name="oldAuthenticator" id="oldAuthenticator" value="${(oldAuthenticator)!}" />
			
			<div class="form-group has-info">
				<label class="control-label col-xs-12 col-sm-3 no-padding-right"
					for="username">用户名:</label>

				<div class="col-xs-12 col-sm-9">
					<div class="clearfix">
						<input type="text" name="username" id="username"
							value="${(user.username)!}" class="col-xs-12 col-sm-5"
							readonly="readonly" disabled="disabled"/>
					</div>
				</div>
			</div>

			<div class="space-2"></div>

			<div class="form-group has-info">
				<label class="control-label col-xs-12 col-sm-3 no-padding-right"
					for="authenticator">密码:</label>

				<div class="col-xs-12 col-sm-9">
					<div class="clearfix">
						<input type="password" name="authenticator" id="authenticator"
							value="${(user.authenticator)!}" class="col-xs-12 col-sm-5"
							 />
					</div>
				</div>
			</div>

			<div class="space-2"></div>

			<div class="form-group has-info">
				<label class="control-label col-xs-12 col-sm-3 no-padding-right">姓名:</label>

				<div class="col-xs-12 col-sm-9">
					<span> <input type="text" name="lastName" id="lastName"
						placeholder="姓" value="${(user.lastName)!}"
						class="col-xs-6 col-sm-2"  /> <input
						type="text" name="firstName" id="firstName" placeholder="名字"
						value="${(user.firstName)!}" class="col-xs-6 col-sm-3"
						 />
					</span>
				</div>
			</div>

			<div class="space-2"></div>

			<div class="form-group has-info">
				<label class="control-label col-xs-12 col-sm-3 no-padding-right">邮箱地址:</label>

				<div class="col-xs-12 col-sm-9">
					<div class="clearfix">
						<input type="text" name="email" id="email"
							value="${(user.email)!}" class="col-xs-12 col-sm-5"
							 />
					</div>
				</div>
			</div>

			<div class="space-2"></div>

			<div class="form-group has-info">
				<label class="control-label col-xs-12 col-sm-3 no-padding-right">手机号码:</label>

				<div class="col-xs-12 col-sm-9">
					<div class="clearfix">
						<input type="text" name="mobile" id="mobile"
							value="${(user.mobile)!}" class="col-xs-12 col-sm-5"
							 />
					</div>
				</div>
			</div>

			<div class="space-2"></div>

			<div class="form-group">
				<label class="control-label col-xs-12 col-sm-3 no-padding-right">固定电话:</label>

				<div class="col-xs-12 col-sm-9">
					<div class="clearfix">
						<input type="text" name="telephone" id="telephone"
							value="${(user.telephone)!}" class="col-xs-12 col-sm-5"
							 />
					</div>
				</div>
			</div>

			<div class="space-2"></div>

			<div class="form-group has-info">
				<label class="control-label col-xs-12 col-sm-3 no-padding-right">部门:</label>

				<div class="col-xs-12 col-sm-9">
					<div class="clearfix">
						<input type="text" name="department" id="department"
							value="${(department)!}" class="col-xs-12 col-sm-2"
							readonly="readonly" />
					</div>
				</div>
			</div>

			<div class="space-2"></div>

			<div class="form-group">
				<label class="control-label col-xs-12 col-sm-3 no-padding-right">办公地点:</label>

				<div class="col-xs-12 col-sm-9">
					<div class="clearfix">
						<input type="text" name="officeLocation" id="officeLocation"
							value="${(user.officeLocation)!}" class="col-xs-12 col-sm-5"
							 />
					</div>
				</div>
			</div>
			
			<div class="clearfix">
				<div class="col-md-offset-3 col-md-9">
					<button class="btn btn-info" type="button" onclick="javascript:user_profile.save();">
						<i class="ace-icon fa fa-check bigger-110"></i> 保存
					</button>

					&nbsp; &nbsp;
					<button class="btn" type="reset">
						<i class="ace-icon fa fa-undo bigger-110"></i> 重置
					</button>
				</div>
			</div>
		</form>
	</div>
	<!-- /.span -->
</div>
<!-- /.user-profile -->