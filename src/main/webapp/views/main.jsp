<!DOCTYPE html>
<html lang="en">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
		<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
		<meta charset="utf-8" />
		<title>优居-<#if currentSystem ??>${currentSystem.title}<#else>管理后台</#if></title>
		<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
		<meta http-equiv="Pragma" content="no-cache" />
		<meta http-equiv="Expires" content="0" />
		<meta name="description" content="" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
		
		<link rel="shortcut icon" href="./favicon.ico" type="image/x-icon">
		<link rel="icon" href="./favicon.ico" type="image/x-icon">
		
		<!-- bootstrap & fontawesome -->
		<link rel="stylesheet" href="./assets/css/bootstrap.css" />
		<link rel="stylesheet" href="./assets/css/font-awesome.css" />

		<!-- page specific plugin styles -->

		<!-- text fonts -->
		<link rel="stylesheet" href="./assets/css/ace-fonts.css" />

		<!-- ace styles -->
		<link rel="stylesheet" href="./assets/css/ace.css" class="ace-main-stylesheet" id="main-ace-style" />
		<link rel="stylesheet" href="./assets/css/bootstrap-datetimepicker.css" />
		<link rel="stylesheet" href="./assets/css/chosen.css" />
		<link rel="stylesheet" href="./assets/css/yoju.css" />
		
		<!--[if lte IE 9]>
			<link rel="stylesheet" href="./assets/css/ace-part2.css" class="ace-main-stylesheet" />
		<![endif]-->

		<!--[if lte IE 9]>
		  <link rel="stylesheet" href="./assets/css/ace-ie.css" />
		<![endif]-->

		<!-- inline styles related to this page -->

		<!-- ace settings handler -->
		<script src="./assets/js/ace-extra.js"></script>

		<!-- HTML5shiv and Respond.js for IE8 to support HTML5 elements and media queries -->

		<!--[if lte IE 8]>
		<script src="./assets/js/html5shiv.js"></script>
		<script src="./assets/js/respond.js"></script>
		<![endif]-->
		
		<!-- basic scripts -->

		<!--[if !IE]> -->
		<script type="text/javascript">
			window.jQuery || document.write("<script src='./assets/js/jquery.js'>"+"<"+"/script>");
		</script>
		<!-- <![endif]-->

		<!--[if IE]>
		<script type="text/javascript">
		 window.jQuery || document.write("<script src='./assets/js/jquery1x.js'>"+"<"+"/script>");
		</script>
		<![endif]-->
		<script type="text/javascript">
			if('ontouchstart' in document.documentElement) document.write("<script src='./assets/js/jquery.mobile.custom.js'>"+"<"+"/script>");
		</script>
		<script src="./assets/js/bootstrap.js"></script>
		<script src="./assets/js/jquery.form.min.js"></script>

		<!-- ace scripts -->
		<script src="./assets/js/ace/elements.scroller.js"></script>
		<script src="./assets/js/ace/elements.colorpicker.js"></script>
		<script src="./assets/js/ace/elements.fileinput.js"></script>
		<script src="./assets/js/ace/elements.typeahead.js"></script>
		<script src="./assets/js/ace/elements.wysiwyg.js"></script>
		<script src="./assets/js/ace/elements.spinner.js"></script>
		<script src="./assets/js/ace/elements.treeview.js"></script>
		<script src="./assets/js/ace/elements.wizard.js"></script>
		<script src="./assets/js/ace/elements.aside.js"></script>
		<script src="./assets/js/ace/ace.js"></script>
		<script src="./assets/js/ace/ace.ajax-content.js"></script>
		<script src="./assets/js/ace/ace.touch-drag.js"></script>
		<script src="./assets/js/ace/ace.sidebar.js"></script>
		<script src="./assets/js/ace/ace.sidebar-scroll-1.js"></script>
		<script src="./assets/js/ace/ace.submenu-hover.js"></script>
		<script src="./assets/js/ace/ace.widget-box.js"></script>
		<script src="./assets/js/ace/ace.widget-on-reload.js"></script>
		<script src="./assets/js/ace/ace.searchbox-autocomplete.js"></script>
		<script src="./assets/js/date-time/moment.js"></script>
		<script src="./assets/js/date-time/bootstrap-datetimepicker.js"></script>
		
		<script src="./assets/js/dataTables/jquery.dataTables.js"></script>
		<script src="./assets/js/dataTables/jquery.dataTables.bootstrap.js"></script>
		<script src="./assets/js/dataTables/extensions/TableTools/js/dataTables.tableTools.js"></script>
		<script	src="./assets/js/dataTables/extensions/ColVis/js/dataTables.colVis.js"></script>
		<script src="./assets/js/bootstrap-dialog.js"></script>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
		<script src="./assets/js/spin.js"></script>
		<!-- page specific plugin scripts -->

		<!-- inline scripts related to this page -->
		<script type="text/javascript">
			var sys = {};
			sys.basePath = "${ctx.getContextPath()}";
			var last = sys.basePath.substring(sys.basePath.length-1, sys.basePath.length);
			if (last=="/")
				sys.basePath = sys.basePath.substring(0, sys.basePath.length-1);
			sys.tabHistory = {};
			sys.userOperations = "${userOperations}";
		
			/* 为tab添加关闭事件 */
			$(document).ready(function() {
				/* disable datatables error prompt */
				$.fn.dataTable.ext.errMode = function ( settings, helpPage, message ) { 
				    console.error(message);
				};

				/**
				* Remove a Tab
				*/
				$('#tabs').on('click', ' li a .close', function() {
					var tabId = $(this).parents('li').children('a').attr('href');
					var id = $(this).parents('li').children('a').attr('data-toggle');
					sys.tabHistory[id] = null;
					
					var prev = $(this).parents('li').prev().find('a');
					$(this).parents('li').remove('li');
					$(tabId).remove();
					
					prev.tab('show')
					//$('#tabs a:first').tab('show');
				});
				
				/*disabled enter button event*/
				document.body.querySelectorAll("button").onkeydown = function(event){
					event.preventDefault();
		        };
		});
			
		</script>
		<script type="text/javascript">
			var ftpserver = '${ftpserver}'
		</script>
		<script src="./assets/js/sysUtils.js"></script>
	</head>

	<body class="no-skin">
		<!-- #section:basics/navbar.layout -->
		<div id="navbar" class="navbar navbar-default">
			<script type="text/javascript">
				try{ace.settings.check('navbar' , 'fixed')}catch(e){}
			</script>

			<div class="navbar-container" id="navbar-container">
				<!-- #section:basics/sidebar.mobile.toggle -->
				<button type="button" class="navbar-toggle menu-toggler pull-left" id="menu-toggler" data-target="#sidebar">
					<span class="sr-only">折叠菜单</span>

					<span class="icon-bar"></span>

					<span class="icon-bar"></span>

					<span class="icon-bar"></span>
				</button>

				<!-- /section:basics/sidebar.mobile.toggle -->
				<div class="navbar-header pull-left">
					<!-- #section:basics/navbar.layout.brand -->
					<a href="#" class="navbar-brand">
						<small>
							<i class="fa fa-leaf"></i>
							优居管理后台
						</small>
					</a>

					<!-- /section:basics/navbar.layout.brand -->

					<!-- #section:basics/navbar.toggle -->

					<!-- /section:basics/navbar.toggle -->
				</div>

				<!-- #section:basics/navbar.dropdown -->
				<div class="navbar-buttons navbar-header pull-right" role="navigation">
					<ul class="nav ace-nav">
						<!-- #section:basics/navbar.user_menu -->
						<li class="light-blue">
							<a data-toggle="dropdown" href="#" class="dropdown-toggle">
								<!-- img class="nav-user-photo" src="./assets/avatars/user.jpg" alt="Jason's Photo" /> -->
								<span class="user-info">
									<small>欢迎,</small>
									${(user.fullName)!}
								</span>

								<i class="ace-icon fa fa-caret-down"></i>
							</a>

							<ul class="user-menu dropdown-menu-right dropdown-menu dropdown-yellow dropdown-caret dropdown-close">
								<li>
									<a href="javascript:sys.userProfile();">
										<i class="ace-icon fa fa-cog"></i>
										个人设置
									</a>
								</li>

								<li>
									<a href="profile.html">
										<i class="ace-icon fa fa-user"></i>
										个人资料
									</a>
								</li>

								<li class="divider"></li>

								<li>
									<a href="./j_spring_cas_security_logout">
										<i class="ace-icon fa fa-power-off"></i>
										退出系统
									</a>
								</li>
							</ul>
						</li>

						<!-- /section:basics/navbar.user_menu -->
					</ul>
				</div>
				<#if systems?? && (systems?size gte 1)>
				<nav role="navigation" class="navbar-menu pull-left collapse navbar-collapse">
					<!-- #section:basics/navbar.nav -->
					<ul class="nav navbar-nav">
						<#list systems as sys>
						<li>
							<#if sys.systemName?? && currentSystem ?? && (sys.systemName == currentSystem.code)>
							<a href="${(sys.url)!}" class="nav-active">
								${sys.title}
							</a>
							<#else>
							<a href="javascript:void(0);" onclick="javascript:sys.changeSystem('${sys.systemName}', '${(sys.url)!}');">
								${sys.title}
							</a>
							</#if>
						</li>
						</#list>
					</ul>
					<!-- /section:basics/navbar.nav -->
				</nav>
				</#if>
				<!-- /section:basics/navbar.dropdown -->
			</div><!-- /.navbar-container -->
		</div>

		<!-- /section:basics/navbar.layout -->
		<div class="main-container" id="main-container">
			<script type="text/javascript">
				try{ace.settings.check('main-container' , 'fixed')}catch(e){}
			</script>

			<!-- #section:basics/sidebar -->
			<div id="sidebar" class="sidebar                  responsive">
				<script type="text/javascript">
					try{ace.settings.check('sidebar' , 'fixed')}catch(e){}
				</script>
				
				<#if menu??>
				<ul class="nav nav-list">
					<#list menu as res>
					<li class="open">
						<#if res.children?size = 0>
						<a href="#">
							<#if res.data.iconClass?? && (res.data.iconClass?length gt 0)>
							<i class="${res.data.iconClass}"></i>
							<#else>
							<i class="menu-icon fa fa-cubes"></i>
							</#if>
							<span class="menu-text"> ${res.data.title} </span>
						</a>
						<b class="arrow"></b>
						
						<#else>
						<a href="#" class="dropdown-toggle">
							<#if res.data.iconClass?? && (res.data.iconClass?length gt 0)>
							<i class="${res.data.iconClass}"></i>
							<#else>
							<i class="menu-icon fa fa-cubes"></i>
							</#if>
							<span class="menu-text"> ${res.data.title} </span>
							<b class="arrow fa fa-angle-down"></b>
						</a>
						<b class="arrow"></b>
						<ul class="submenu">
						<#list res.children as res1>
							<li class="">
								<a href="#" onclick="sys.openTab(this,'${res1.data.url}','${res1.data.title}');">
									<i class="menu-icon fa fa-caret-right"></i>
									${res1.data.title}
								</a>
								<b class="arrow"></b>
							</li>
						</#list>
						</ul>
						</#if>
					</li>
					</#list>
				</ul><!-- /.nav-list -->
				<#else>
					&nbsp;&nbsp;&nbsp;&nbsp;缺少相关权限
				</#if>
				<!-- #section:basics/sidebar.layout.minimize -->
				<div class="sidebar-toggle sidebar-collapse" id="sidebar-collapse">
					<i class="ace-icon fa fa-angle-double-left" data-icon1="ace-icon fa fa-angle-double-left" data-icon2="ace-icon fa fa-angle-double-right"></i>
				</div>

				<!-- /section:basics/sidebar.layout.minimize -->
				<script type="text/javascript">
					try{ace.settings.check('sidebar' , 'collapsed')}catch(e){}
				</script>
			</div>

			<!-- /section:basics/sidebar -->
			<div class="main-content">
				<div class="main-content-inner">

					<div class="page-content">
						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
								<div id="main_content">

									<!-- #section:elements.tab -->
									<div class="tabbable">
										<ul class="nav nav-tabs" id="tabs">
											<li class="active">
												<a data-toggle="tab" href="#home"> 欢迎 </a></li>
										</ul>

										<div id="tabs-content" class="tab-content">
											<div id="home" class="tab-pane fade in active">
												<p>欢迎使用。</p>
											</div>

										</div>
									</div>

									<!-- /section:elements.tab -->
								</div>

								<!-- PAGE CONTENT ENDS -->
							</div>
							<!-- /.col -->
						</div><!-- /.row -->
					</div><!-- /.page-content -->
				</div>
			</div><!-- /.main-content -->

			<div class="footer">
				<div class="footer-inner">
					<!-- #section:basics/footer -->
					<div class="footer-content">
						<span class="bigger-120">
							<span class="blue">&copy; 2015 深圳前海优品优居网络科技有限公司</span>
						</span>
					</div>

					<!-- /section:basics/footer -->
				</div>
			</div>

			<a href="#" id="btn-scroll-up" class="btn-scroll-up btn btn-sm btn-inverse">
				<i class="ace-icon fa fa-angle-double-up icon-only bigger-110"></i>
			</a>
		</div><!-- /.main-container -->
		<div class="notification js-notification"></div>
	</body>
</html>
