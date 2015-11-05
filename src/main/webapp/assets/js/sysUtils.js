/**
* 判断用户是否对某按钮有有权限
*/
sys.hasPermission = function(operationCode) {
	var found = sys.userOperations.indexOf(operationCode);
	if (found>0)
		return true;
	else
		return false;
};
/**
* 当ajax请求中时添加遮罩层，与提示
*/
jQuery(document).ajaxStart(function () {
	sys.ajax_indicator_start('数据加载中...');
}).ajaxComplete(function() {
	sys.ajax_indicator_stop();
}).ajaxError(function(event, xhr, settings, error){
	if (!error || error.length==0) {
		sys.alertInfo('对不起，登录可能超时，请刷新页面后重试', 'warning');
	} else if (xhr.status == 403) {
		sys.alertInfo('对不起，您缺少相应权限', 'warning');
	} else {
		sys.alertInfo('对不起，出现错误，请刷新页面后重试: ' + xhr.status + ' ' + error, 'danger');
	}
	console.error(event, xhr, error);
});

sys.ajax_indicator_start = function(text) {
	if(jQuery('#main_content').find('#resultLoading').attr('id') != 'resultLoading'){
		jQuery('#main_content').append('<div id="resultLoading" style="display:none"><div><i class="ace-icon fa fa-spinner fa-spin orange bigger-125"></i><div>'+text+'</div></div><div class="bg"></div></div>');
	}
    jQuery('#resultLoading .bg').height('100%');
    jQuery('#resultLoading').show();
    jQuery('#main_content').css('cursor', 'wait');
};

sys.ajax_indicator_stop = function() {
    jQuery('#resultLoading .bg').height('100%');
    jQuery('#resultLoading').fadeOut(300);
    jQuery('#main_content').css('cursor', 'default');
};

/** 为jQuery datatables统一添加 行选择行为，选择列 和 导出Excel 两个按钮 
* unSelectableCol: 哪一列上点击不会触发选择行，通常是操作列，从1开始算
* btnContainerSelector: table tools容器
* exportFunc: 导出Excel按钮触发的动作函数名，为字符串
*/
sys.addDatatableTools = function(unSelectableCol, btnContainerSelector, exportFunc, tableId, targetOTable) {
	//TableTools settings
	TableTools.classes.container = "btn-group btn-overlap";

	//initiate TableTools extension
	var tableTools_obj = new $.fn.dataTable.TableTools( targetOTable, {
		"sRowSelector": "td:not(:nth-child(" + unSelectableCol + "))", // starting with 1
		"sRowSelect": "multi",
		"fnRowSelected": function(row) {
			//check checkbox when row is selected
			try { $(row).find('input[type=checkbox]').get(0).checked = true }
			catch(e) {}
		},
		"fnRowDeselected": function(row) {
			//uncheck checkbox
			try { $(row).find('input[type=checkbox]').get(0).checked = false }
			catch(e) {}
		},

		"sSelectedClass": "success", // selected class!!!
        "aButtons": [
        ]
    } );
	//we put a container before our table and append TableTools element to it
    $(tableTools_obj.fnContainer()).appendTo($(btnContainerSelector));
	
	//ColVis extension
	var colvis = new $.fn.dataTable.ColVis( targetOTable, {
		"buttonText": "<i class='fa fa-search'></i>",
		"aiExclude": [0, 6],
		"bShowAll": true,
		"bRestore": true,
		"sAlign": "right",
		"fnLabel": function(i, title, th) {
			return $(th).text();//remove icons, etc
		}
	}); 
	
	//style it
	$(colvis.button()).addClass('btn-group').find('button').addClass('btn btn-white btn-info btn-bold')
	
	//and append it to our table tools btn-group, also add tooltip
	$(colvis.button())
	.prependTo(btnContainerSelector + ' .btn-group')
	.attr('title', '选择列').tooltip({container: 'body'});
	
	//and make the list, buttons and checkboxed Ace-like
	$(colvis.dom.collection)
	.addClass('dropdown-menu dropdown-light dropdown-caret dropdown-caret-right')
	.find('li').wrapInner('<a href="javascript:void(0)" />') //'A' tag is required for better styling
	.find('input[type=checkbox]').addClass('ace').next().addClass('lbl padding-8');
	
	/////////////////////////////////
	//table checkboxes
	$('th input[type=checkbox], td input[type=checkbox]').prop('checked', false);
	
	//select/deselect all rows according to table header checkbox
	$(tableId + ' > thead > tr > th input[type=checkbox]').eq(0).on('click', function(){
		var th_checked = this.checked;//checkbox inside "TH" table header
		
		$(this).closest('table').find('tbody > tr').each(function(){
			var row = this;
			if(th_checked) tableTools_obj.fnSelect(row);
			else tableTools_obj.fnDeselect(row);
		});
	});
	
	//select/deselect a row when the checkbox is checked/unchecked
	$(tableId).on('click', 'td input[type=checkbox]' , function(){
		var row = $(this).closest('tr').get(0);
		if(!this.checked) tableTools_obj.fnSelect(row);
		else tableTools_obj.fnDeselect($(this).closest('tr').get(0));
	});
	
	var exportXls = $('<div class="btn-group" title="导出Excel" data-original-title="导出Excel">\
		<button onclick="javascript:' + exportFunc + ';" class="btn btn-white btn-info btn-bold"><span>\
		<i class="fa fa-file-excel-o bigger-110 green"></i></span></button></div>')
	.tooltip({container: 'body'});
	
	exportXls.prependTo($(btnContainerSelector).find('.btn-group:first'));
};

/**
* 导出excel操作，数据来自当前表格
*/
sys.exportExcel = function(tableSelector, exportUrl, fileName) {
	var table = $(tableSelector).DataTable();
	var cols = $(tableSelector).dataTable().fnSettings().aoColumns;
	
	var colDefs = [], headers = [];
	for (var i=0; i<cols.length;i++) {
		var colName = cols[i]['name'];
		var dataIndex = cols[i]['data'];
		var header = cols[i]['sTitle'];
		
		if (colName!='id' && cols[i].bVisible && header && header!='操作' && header.substring(0,1)!='<') {
        	colDefs.push(header);
        	headers.push(header);
		} else {
			colDefs.push(false);
		}
	}
	
	var rows = [];
	for (var i=0; i<table.rows().data().length;i++) {
		var data = table.rows(i).cells().render('display');
		var row = [];
		for (var j=0; j<data.length; j++) {
			if (colDefs[j]!=false) {
				row.push(data[j]);
			}
		}
		rows.push(row);
	}
	
	var params = {};
	params.headers = JSON.stringify(headers);
	params.rows = JSON.stringify(rows);
	params.fileName = fileName;
	sys.postToUrl(exportUrl, params);
};

sys.postToUrl = function(path, params, method) {
     method = method || "post"; 
     var form = document.createElement("form");
     form.setAttribute("method", method);
     form.setAttribute("action", path);
     for(var name in params) {
    	 if (params.hasOwnProperty(name)) {
    		 var hiddenField = document.createElement("input");
	         hiddenField.setAttribute("type", "hidden");
	         hiddenField.setAttribute("name", name);
	         hiddenField.setAttribute("value", params[name]);
	         form.appendChild(hiddenField);
    	 }
     }   
     document.body.appendChild(form);   
     form.submit();
};

sys.userProfile = function() {
	var dialog = new BootstrapDialog({
		draggable: true,
    	closable: true,
    	closeByBackdrop: false,
        closeByKeyboard: false,
        title: '个人设置',
        message: $('<div></div>').load(sys.basePath + '/user/profile.do')
    });
	dialog.open();
};

/**
* 弹出确认窗口，确定后执行func(dialogRef)
*/
sys.confirm = function(title, message, func) {
	var delConfirmDialog = new BootstrapDialog({
    	closable: true,
    	title: title,
        message: message,
        buttons: 
        	[
			  {
			    label: '确定',
			    cssClass: 'btn-danger',
			    action: function(dialogRef) {
			    	func(dialogRef);
			    }
			 },
        	 {
        		label:'取消',
        		cssClass: 'btn-default',
        		action: function(dialogRef) {
        			dialogRef.close();
        		}
        	 }
           ]
    });
	delConfirmDialog.open();
};

/* 在弹出的bootstrap dialog中以JSON格式提交表单(object={...})，完成后关闭dialog并刷新jquery datatable */
sys.ajax = function(formSelector, window, datatable) {
	var obj = sys.form2Object(formSelector);
	$.ajax({
		url: $(formSelector).attr('action'),
		type: "POST",
		dataType: "json",
		data: {"object": JSON.stringify(obj)},
		success:function(response,st, xhr) {
			if(typeof(response.success)=="undefined"){
				$.messager.alert(sy_remind,"无结果返回/登录超时或未登录");
				return;
			}
			if (response.success == true) {
				window.close();
				if (datatable)
					datatable.ajax.reload( null, false );
				console.debug(response.msg);
			}else {
				console.error(response.msg);
			}
		},
		error:function(xhr,type,msg){
			console.error(msg);
		}
	});
};

/* 在弹出的bootstrap dialog中提交表单，完成后关闭dialog并刷新jquery datatable */
sys.ajaxSubmit = function(formSelector, window, datatable) {
	console.error("formSelector", $(formSelector).attr('action'));
	if ($(formSelector).valid()) {
		//$("#indexDivSaving").show();
		$(formSelector).ajaxSubmit({
			
			success : function(response) {
				if(typeof(response.success)=="undefined"){
					$("#indexDivSaving").hide();
					$.messager.alert(sy_remind,"无结果返回/登录超时或未登录");
					return;
				}
				if (response.success == true) {
					window.close();
					if (datatable)
						datatable.ajax.reload( null, false );
					console.debug(response.msg);
				}else {
					console.error(response.msg);
				}
			}
		});
	}
};

/* 把表单的fields转换成object的属性 */
sys.form2Object = function(formSelector,obj){
	obj=obj||{};
	var fields=$(formSelector).find("input:text,input:hidden,input:password,select,textarea");
	
	var checkboxFiels = $(formSelector).find("input:checkbox");
	checkboxFiels.each(function(ind,elm){
		fields.push($(elm));
	});
	
	var radioFiels = $(formSelector).find("input:radio:checked");
	radioFiels.each(function(ind,elm){
		fields.push($(elm));
	});
	
	fields.each(function(index,domObj){
		var item=$(domObj);
        if(item.attr("name")){
           if(item.attr("type")&&item.attr("type").toLowerCase()=="radio"){	          
              //if(item.attr("checked") && (item.attr("checked")===true || item.attr("checked") =="true" || item.attr("checked") == "checked")){	          
              if(item.is(":checked")) {
                 obj[item.attr("name")]=item.val();
              }
           }else if(item.attr("type")&&item.attr("type").toLowerCase()=="checkbox"){
	        	 //checked 当复选框用作单选作用时,勾选复选框是value应为true/1/yes或其它,反选复选框时以为false/0/no.
				//<k:checkbox formatRules="{checkedValueMap:{checked:true,unChecked:false}}"/>,
				//<k:checkbox formatRules="{checkedValueMap:{checked:1,unChecked:0}}"/>,
				//<k:checkbox formatRules="{checkedValueMap:{checked:yes,unChecked:no}}"/>,
				//和jq-format-impl.js checkedValueMap 实现方法对应
        	  if(item.attr("formatRules") && item.attr("formatRules").length>0 && $.parseJSON(item.attr("formatRules")).checkedValueMap){
        		  obj[item.attr("name")] = item.val();
        	  }else{
        		  //if(item.attr("checked")!=undefined){
        			  //if(item.attr("checked").length>0 || item.attr("checked") =="true" || item.attr("checked") == "checked"){
        		      if (item.is(":checked")) {
        				  obj[item.attr("name")] = true;	
        			  } else {
        				  obj[item.attr("name")] = false;
        			  }
				}
    	  }else {
			if (typeof item.val()==='string' && item.val().length==0 && item.attr("type")&&item.attr("type").toLowerCase()=="hidden") {
				// don't set hidden Id value as ""
				obj[item.attr("name")] = null;
			} else {
				obj[item.attr("name")] = item.val();
			}
		  }
		}// if name
	 });
	return obj;  
};

/* 把object的属性转换成表单的fields */
sys.object2Form = function(formSelector, obj) {
	var fields = $(formSelector).find("input,select,textarea");
	
	fields.each(function(index,domObj){
        var item=$(domObj);
        if(item.attr("name")){
           if(item.attr("type")&&item.attr("type").toLowerCase()=="radio"){	          
              if(obj[item.attr("name")]!=null&&obj[item.attr("name")].toString()==item.val()){	          
                 item.attr("checked",true);
                 delete obj[item.attr("name")]; 
              }
           }else if(item.attr("type")&&item.attr("type").toLowerCase()=="checkbox"){
        	   //点击事件，清除checked属性
        	   //item.bind("click",_this.handleCheckboxClick);
        	   //checked 当复选框用作单选作用时,勾选复选框是value应为true/1/yes或其它,反选复选框时以为false/0/no.
				//<k:checkbox formatRules="{checkedValueMap:{checked:true,unChecked:false}}"/>,
				//<k:checkbox formatRules="{checkedValueMap:{checked:1,unChecked:0}}"/>,
				//<k:checkbox formatRules="{checkedValueMap:{checked:yes,unChecked:no}}"/>,
				//和jq-format-impl.js checkedValueMap 实现方法对应
        	   if(item.attr("formatRules") && item.attr("formatRules").length>0 && $.parseJSON(item.attr("formatRules")).checkedValueMap){
        		   var checkedValueMap = $.parseJSON(item.attr("formatRules")).checkedValueMap;
        		   if(obj[item.attr("name")]!=null){
        			   if(checkedValueMap.checked.toString() == obj[item.attr("name")].toString()){
        				   item.attr("checked",true);
        			   }else{
        				   item.removeAttr("checked");
        			   }
        			   item.val(obj[item.attr("name")].toString());
        		   }
        	   }else{
        		   if(obj[item.attr("name")]!=null && obj[item.attr("name")].toString() == 'true'){	          
						item.attr("checked",true);
					}else{
						item.removeAttr("checked");
					}
        	   }
           } else if((item.attr("type")&&item.attr("type").toLowerCase()=="select-one")||item.is('select')){
           		// select
           		var optionItem = $("option[value='"+obj[item.attr("name")]+"']", item);
           		optionItem.attr("selected", true);
           } else {
        	   item.val(obj[item.attr("name")]);
           }
        }
	});
};

/* 在tab里跳转到另外的链接 */
sys.goInTab = function(id, url, name) {
	if (sys.tabHistory[id]) {
		var urlName = {};
		urlName['url'] = url;
		urlName['name'] = name;
		sys.tabHistory[id].push(urlName);
		
		$('#' + id + '_content').load(url);
		$('#tabs a[data-toggle="' + id + '"]').attr('href', '#' + id + '_content').html(name + '<button class="close" type="button" title="关闭页面">×</button>');
	} else {
		console.error("tab " + id + " is not found, openTab first.");
	}
};

/* 在tab里返回上一个链接(重新加载) */
sys.backInTab = function(id) {
	if (sys.tabHistory[id] && sys.tabHistory[id].length>1) {
		sys.tabHistory[id].pop();
		var urlName = sys.tabHistory[id][sys.tabHistory[id].length-1];
		
		$('#' + id + '_content').load(urlName.url);
		$('#tabs a[data-toggle="' + id + '"]').attr('href', '#' + id + '_content').html(urlName.name + '<button class="close" type="button" title="关闭页面">×</button>');
	} else {
		console.error("tab " + id + " is not found.");
		sys.alertInfo('对不起，登录可能超时，请刷新页面后重试', 'warning');
	}
};

/* 在tabs容器添加新的tab */
sys.addTab = function(id, url, name) {
	$('#tabs').append($('<li id="' + id + '">\
			<a data-toggle="' + id + '" href="#' + id + '_content">' + name + 
			'<button class="close" type="button"\
			title="关闭页面">×</button>\
			</a>\
	</li>'));
	
	$('#tabs-content').append($('<div id="' + id + '_content" class="tab-pane fade"></div>'));
	$('#' + id + ' a').on('shown.bs.tab', function (e) {
		if (!this["loaded"]) {
			this["loaded"] = true;
			$('#' + id + '_content').load(url);
		}
		// activate menu
		var $li = $('#li_'+id);
		if (!$li.hasClass("active")) {
			$(".nav-list li").removeClass("active");
			$li.addClass("active");
		}
	});
	$('#' + id + ' a').tab('show');
	$('#' + id + ' a').click(function (e) {
		e.preventDefault();
		$(this).tab('show');
	});
};

/* 打开tab, 如果tab已经存在则激活，否则添加新的tab */
sys.openTab = function(target, url, name) {
	if (url.charAt(0)=='/')
		url = url.substring(1);
	
	var id = url.replace(/\//g,"_");
	var dotIdx = id.indexOf("\.");
	if (dotIdx>0)
		id = id.substring(0, dotIdx);
	
	var $target = $(target);
	// activate menu
	var $li = $target.closest('li');
	if (!$li.hasClass("active")) {
		$(".nav-list li").removeClass("active");
		$li.addClass("active");
	}
	
	$li.attr('id', 'li_' + id);
	$('#tabs .active').each(function(){
		$(this).removeClass("active");
	});
	
	
	var $tab = $('#tabs').find('#' + id);
	if (!$tab.length) {
		sys.addTab(id, url, name);
		
		var urlName = {};
		urlName['url'] = url;
		urlName['name'] = name;
		sys.tabHistory[id] = [urlName];
	} else {
		$tab.find('a').tab('show');
	}
};

/* 消息提示 */
// msg: 提示消息     cssCls: 显示样式   可选值（success/info/warning/danger）
sys.alertInfo = function(msg, cssCls) {
	var $notificationEle = $("body .js-notification");
	$notificationEle.html('<div class="alert alert-'+cssCls+' fade in">' +
				'<button type="button" class="close" aria-hidden="true" onclick="javascript:$(\'.alert\').alert(\'close\');">&times;</button>'+msg+'</div>');
	window.setTimeout(function(){
		$notificationEle.find('.alert').alert('close');
	}, 3500);
};

sys.changeSystem = function(sysName, url) {
	sys.setCookie('CURRENT_SYSTEM', sysName, 5);
	window.location.href = url;
};

sys.setCookie = function(name,value,days) {
    if (days) {
        var date = new Date();
        date.setTime(date.getTime()+(days*24*60*60*1000));
        var expires = "; expires="+date.toGMTString();
    }
    else var expires = "";
    document.cookie = name+"="+value+expires+"; path=/";
};