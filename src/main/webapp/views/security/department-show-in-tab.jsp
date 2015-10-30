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

var dept_show = {};

dept_show.save = function() {
	if (!$('#department-edit-form').valid())
		return;
	
	var obj = sys.form2Object('#department-edit-form');
	$.ajax({
		url: $('#department-edit-form').attr('action'),
		type: "POST",
		dataType: "json",
		data: {"object": JSON.stringify(obj)},
		success:function(response,st, xhr) {
			if(typeof(response.success)=="undefined"){
				$.messager.alert(sy_remind,"无结果返回/登录超时或未登录");
				return;
			}
			if (response.success == true) {
				sys.alertInfo(response.msg, 'success');
				sys.backInTab('department_index');
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

dept_show.back = function() {
	sys.backInTab('department_index');
};
</script>
<form class="form-horizontal" id="department-edit-form" method="post" action="${ctx.getContextPath()}/department/save.do">
	<input type="hidden" name="id" id="id" value="${(department.id)!}"/>
	
	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="title">部门名称:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="title" id="title" value="${(department.title)!}"
					class="col-xs-12 col-sm-8" />
			</div>
		</div>
	</div>

	<div class="space-2"></div>

	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="password">部门编码:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="code" id="code" value="${(department.code)!}"
					class="col-xs-12 col-sm-8" />
			</div>
		</div>
	</div>

	<div class="space-2"></div>

	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="password2">描述:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="description" id="description" value="${(department.description)!}"
					class="col-xs-12 col-sm-12" />
			</div>
		</div>
	</div>
	
	<div class="form-group">
		<div class="col-xs-12 col-sm-9 center">
			<div class="clearfix">
				<button type="button" class="btn btn-info" onclick="javascript:dept_show.save();">
   					<i class="ace-icon fa fa-floppy-o"></i>保存
 				</button>
 				<button type="button" class="btn btn-info" onclick="javascript:dept_show.back();">
   					<i class="ace-icon fa fa-times red2"></i>取消
 				</button>
			</div>
		</div>
	</div>
	<div class="hr hr-dotted"></div>
</form>