<form class="form-horizontal" id="user-edit-form" >
	<input type="hidden" name="id" id="id" value="${(user.id)!}"/>
	
	<div class="form-group has-info">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="username">用户名:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="username" id="username" value="${(user.username)!}"
					class="col-xs-12 col-sm-5" readonly="readonly"/>
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
					class="col-xs-12 col-sm-5" readonly="readonly"/>
			</div>
		</div>
	</div>

	<div class="space-2"></div>

	<div class="form-group has-info">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right">姓名:</label>

		<div class="col-xs-12 col-sm-9">
			<span>
				<input type="text" name="lastName" id="lastName" placeholder="姓" value="${(user.lastName)!}"
					class="col-xs-6 col-sm-2" readonly="readonly" />
				<input type="text" name="firstName" id="firstName" placeholder="名字" value="${(user.firstName)!}"
					class="col-xs-6 col-sm-3" readonly="readonly" />
			</span>
		</div>
	</div>
	
	<div class="space-2"></div>

	<div class="form-group has-info">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right">邮箱地址:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="email" id="email" value="${(user.email)!}"
					class="col-xs-12 col-sm-5" readonly="readonly" />
			</div>
		</div>
	</div>
	
	<div class="space-2"></div>

	<div class="form-group has-info">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right">手机号码:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="mobile" id="mobile" value="${(user.mobile)!}"
					class="col-xs-12 col-sm-5" readonly="readonly" />
			</div>
		</div>
	</div>
	
	<div class="space-2"></div>

	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right">固定电话:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="telephone" id="telephone" value="${(user.telephone)!}"
					class="col-xs-12 col-sm-5" readonly="readonly" />
			</div>
		</div>
	</div>
	
	<div class="space-2"></div>

	<div class="form-group has-info">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right">部门:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="department" id="department" value="${(department)!}"
					class="col-xs-12 col-sm-2" readonly="readonly" />
			</div>
		</div>
	</div>
	
	<div class="space-2"></div>

	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right">办公地点:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="officeLocation" id="officeLocation" value="${(user.officeLocation)!}"
					class="col-xs-12 col-sm-5" readonly="readonly" />
			</div>
		</div>
	</div>
	
	<div class="space-2"></div>
	
	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="password2">可否可用:</label>

		<div class="col-xs-12 col-sm-2">
			<div class="clearfix">
				<input type="checkbox" class="ace" name="status" id="status" <#if user??&&user.status>checked</#if> disabled="disabled"/>
				<span class="lbl"></span>
			</div>
		</div>
	</div>
</form>