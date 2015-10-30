<script src="./assets/js/jquery.validate.js"></script>

<form class="form-horizontal" id="role-edit-form" method="post" action="#">
	<input type="hidden" name="id" id="id" value="${role.id}"/>
	
	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="title">角色名称:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="title" id="title" value="${role.title}"
					class="col-xs-12 col-sm-8" readonly="readonly"/>
			</div>
		</div>
	</div>

	<div class="space-2"></div>

	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="code">角色编码:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="code" id="code" value="${role.code}"
					class="col-xs-12 col-sm-8" readonly="readonly"/>
			</div>
		</div>
	</div>

	<div class="space-2"></div>

	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="description">描述:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="description" id="description" value="${role.description}"
					class="col-xs-12 col-sm-12" readonly="readonly"/>
			</div>
		</div>
	</div>
	
	<div class="space-2"></div>
	
	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="status">是否可用:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="checkbox" class="ace ace-switch ace-switch-5" name="status" id="status" <#if role.status>checked</#if> disabled="disabled"/>
				<span class="lbl middle"></span>
			</div>
		</div>
	</div>
</form>