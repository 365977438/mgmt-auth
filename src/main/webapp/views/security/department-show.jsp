<script src="./assets/js/jquery.validate.js"></script>

<script type="text/javascript">
jQuery(function($) {
	
	$('#department-edit-form').validate({
		errorElement: 'div',
		errorClass: 'help-block',
		focusInvalid: false,
		ignore: "",
		rules: {
			title: {
				required: true
			},
			code: {
				required: true,
				minlength: 5
			},
			description: {
				required: false
			}
		},
	
		messages: {
			title: {
				required: "请输入名称."
			},
			code: {
				required: "请输入编码.",
				minlength: "编码长度至少5位."
			}
		},
	
	
		highlight: function (e) {
			$(e).closest('.form-group').removeClass('has-info').addClass('has-error');
		},
	
		success: function (e) {
			$(e).closest('.form-group').removeClass('has-error');//.addClass('has-info');
			$(e).remove();
		},
	
		submitHandler: function (form) {
		},
		invalidHandler: function (form) {
		}
	});
});
</script>
<form class="form-horizontal" id="department-edit-form" method="post" action="${ctx.getContextPath()}/department/save.do">
	<input type="hidden" name="id" id="id" value="${department.id}"/>
	
	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="title">部门名称:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="title" id="title" value="${department.title}"
					class="col-xs-12 col-sm-8" readonly="readonly"/>
			</div>
		</div>
	</div>

	<div class="space-2"></div>

	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="password">部门编码:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="code" id="code" value="${department.code}"
					class="col-xs-12 col-sm-8" readonly="readonly"/>
			</div>
		</div>
	</div>

	<div class="space-2"></div>

	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="password2">描述:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="description" id="description" value="${department.description}"
					class="col-xs-12 col-sm-12" readonly="readonly"/>
			</div>
		</div>
	</div>
</form>