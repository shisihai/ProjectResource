﻿
var indexAddTab="";//全局变量
(function ($) {

    $.util.namespace("mainpage.nav");
    $.util.namespace("mainpage.favo");
    $.util.namespace("mainpage.mainTabs");

    var homePageTitle = "主页", homePageHref = null,
        navMenuTree = "#navMenu_Tree", mainTabs = "#mainTabs", navTabs = "#navTabs", favoMenuTree = "#favoMenu_Tree",
        mainLayout = "#mainLayout", northPanel = "#northPanel", themeSelector = "#themeSelector",
        westLayout = "#westLayout", westCenterLayout = "#westCenterLayout", westFavoLayout = "#westFavoLayout",
        westSouthPanel = "#westSouthPanel", homePanel = "#homePanel",
        btnFullScreen = "#btnFullScreen";
    /**
     * 新增tab extended  by leejean
     */
    var addPanel=function(node){
    	if (node.attributes && node.attributes.href) {
			var url;
			if (node.attributes.href.indexOf(':') ==-1) {/*如果url不包含':'，那么代表打开的是本地的资源*/
				url = $.basePath+"/"+ node.attributes.href;
			} else {/*打开跨域资源*/
				url = node.attributes.href;
			}			
			addTab({
				url : url,
				title : node.text,
				iconCls : node.iconCls
			});
		}
    };
    /**
     * 新增tab extended  by leejean
     */
    var addTab=function(params) {
		var iframe = '<iframe src="' + params.url + '" frameborder="0" style="border:0;width:100%;height:99.3%;padding:0px;margin:0px;"></iframe>';
		var t = $(mainTabs);		
		var opts = {
			title : params.title,
			closable : true,
			iconCls : params.iconCls,
			content : iframe,
			border : false,
			fit : true,
			url: params.url
		};
		if (t.tabs('exists', opts.title)) {
			t.tabs('select', opts.title);			
		} else {
			t.tabs('add', opts);
		}
	};
	/**
	 * 调用页面 新增tab
	 */
	indexAddTab =function(params){
		addTab(params);
	}

    //  将指定的根节点数据集合数据加载至左侧面板中“导航菜单”的 ul 控件中；该方法定义如下参数：
    //      callback:  为一个 Function 对象；表示家在完成菜单数据后调用的回调函数
    window.mainpage.loadNavMenus = function (callback) {
    	$(navMenuTree).tree({
    		 method: "get",             
             url: $.basePath+"/pms/sysRes/getUserMenus.do",
             enableContextMenu:false,
             onLoadSuccess:function(){
            	 $(navMenuTree).tree('collapseAll');
             }
    	});
       
    };
    /**
     * 初始化tree node 状态
     */
    window.mainpage.instTreeStatus = function (target) {
        var t = $(target), array = t.tree("getRoots");
        $.each(array, function (i, n) {
            var cc = t.tree("getChildren", n.target);
            t.tree("expand", n.target);
            $.each(cc, function (l, c) { t.tree("collapseAll", c.target); });
        });
    };

    /**
     * 初始化 westSouthPanel 位置的“导航菜单”区域子菜单 ul 控件(仅初始化 easyui-tree 对象，不加载数据)。
     */
    window.mainpage.instNavTree = function () {
    	 var t = $(navMenuTree);
         if (t.isEasyUI("tree")) { return; }
         t.tree({
             animate: true,
             lines: false,
             toggleOnClick: true,
             selectOnContextMenu: true,
             showOption: true,
             dataPlain: true,       //该属性用以启用当前 easyui-tree 控件对平滑数据格式的支持                          
             enableContextMenu: true,
             onClick: function (node) {
            	 //window.mainpage.addModuleTab(node);//此方法add tabs导致内容出现滚动条
                 addPanel(node);
                 //window.mainpage.setTheme($.cookie("themeName"), true);
             },
             onLoadSuccess: function (node, data) {
                // $(navMenuList).find("a").removeAttr("disabled");
                 window.mainpage.instTreeStatus(t);
                 $.easyui.loaded(westCenterLayout);
             },
             contextMenu: [
                 {
                     text: "打开/转到", iconCls: "icon-standard-application-add",
                     disabled: function (e, node) { return node.attributes && node.attributes.href ? false : true; },
                     handler: function (e, node) {
                         window.mainpage.addModuleTab(node);
                     }
                 }, "-",
                 { text: "添加至个人收藏", iconCls: "icon-standard-feed-add", disabled: function (e, node) { return !t.tree("isLeaf", node.target); }, handler: function (e, node) { window.mainpage.nav.addFavo(node.id); } },
                 { text: "重命名", iconCls: "icon-hamburg-pencil", handler: function (e, node) { t.tree("beginEdit", node.target); } }, "-",
                 { text: "刷新", iconCls: "icon-cologne-refresh", handler: function (e, node) { window.mainpage.nav.refreshTree(); } }
             ],
             onAfterEdit: function (node) { window.mainpage.nav.rename(node.id, node.text); }
         });    	        
    };

    //  初始化应用程序主界面左侧面板中“导航菜单”的数据，并加载特定的子菜单树数据。
    window.mainpage.instMainMenus = function () {
    	window.mainpage.instNavTree();
    	window.mainpage.loadNavMenus();
    };



    //  初始化 westSouthPanel 位置“个人收藏”的 ul 控件(仅初始化 easyui-tree 对象，不加载数据)。
    window.mainpage.instFavoTree = function () {
        var t = $(favoMenuTree);
        if (t.isEasyUI("tree")) { return; }
        t.tree({
            method: "get",
            animate: true,
            lines: false,
            dataPlain: true,
            dnd: true,
            toggleOnClick: true,
            showOption: true,
            dataPlain: true,       //该属性用以启用当前 easyui-tree 控件对平滑数据格式的支持                          
            enableContextMenu: true,
            onBeforeDrop: function (target, source, point) {
                var node = $(this).tree("getNode", target);
                if (point == "append" || !point) {
                    if (!node || !node.attributes || !node.attributes.folder) { return false; }
                }
            },
            selectOnContextMenu: true,
            onClick: function (node) {
                //window.mainpage.addModuleTab(node);//此方法add tabs导致内容出现滚动条
            	addPanel(node);
            },
            onLoadSuccess: function (node, data) {
                window.mainpage.instTreeStatus(t);
                $.easyui.loaded(westFavoLayout);
            },
            contextMenu: [
                {
                    text: "打开/转到", iconCls: "icon-standard-application-add", handler: function (e, node) { window.mainpage.addModuleTab(node); }
                }, "-",
                { text: "添加目录", iconCls: "icon-standard-folder-add", handler: function (e, node) { window.mainpage.favo.addFolder(node); } }, "-",
                { text: "从个人收藏删除", iconCls: "icon-standard-feed-delete", handler: function (e, node) { window.mainpage.favo.removeFavo(node.id); } },
                { text: "重命名", iconCls: "icon-hamburg-pencil", handler: function (e, node) { t.tree("beginEdit", node.target); } }, "-",
                { text: "刷新", iconCls: "icon-cologne-refresh", handler: function (e, node) { window.mainpage.favo.refreshTree(); } }
            ],
            onAfterEdit: function (node) { window.mainpage.favo.rename(node.id, node.text); }
        });
    };

    //  加载我的收藏数据
   
    window.mainpage.loadFavoMenus= function () {
        //$.easyui.loading({ locale: westFavoLayout });
        $(favoMenuTree).tree({
            method: "get",
            url: $.basePath+"/pms/sysRes/getUserFavorites.do",
            dataPlain:true,
            enableContextMenu:false,
            onLoadSuccess:function(){
           	$(favoMenuTree).tree('collapseAll');
            }
        });
    };
    //  初始化应用程序主界面左侧面板中“个人收藏”的数据。
    window.mainpage.instFavoMenus = function () {
        window.mainpage.instFavoTree();
        window.mainpage.loadFavoMenus();
    };


    //初始化时间
    window.mainpage.instTimerSpan = function () {
        var timerSpan = $("#systemTime"), interval = function () { timerSpan.text($.date.toLongDateTimeString(new Date())); };
        interval();
        window.setInterval(interval, 1000);
    };
    //皮肤
    window.mainpage.bindToolbarButtonEvent = function () {
      
        $("#btnHideNorth").click(function () { window.mainpage.hideNorth(); });
        var btnShow = $("#btnShowNorth").click(function () { window.mainpage.showNorth(); });
        var l = $(mainLayout), north = l.layout("panel", "north"), panel = north.panel("panel"),
            toolbar = $("#toolbar"), topbar = $("#topbar");
        opts = north.panel("options"), onCollapse = opts.onCollapse, onExpand = opts.onExpand;
        opts.onCollapse = function () {
            if ($.isFunction(onCollapse)) { onCollapse.apply(this, arguments); }
            btnShow.show();
            toolbar.insertBefore(panel).addClass("top-toolbar-topmost");
        };
        opts.onExpand = function () {
            if ($.isFunction(onExpand)) { onExpand.apply(this, arguments); }
            btnShow.hide();
            toolbar.insertAfter(topbar).removeClass("top-toolbar-topmost");
        };

        var themeName = $.cookie("themeName"),
            themeCombo = $(themeSelector).combobox({
                width: 100, editable: false,
                data: window.mainpage.themeData,
                valueField: "path", textField: "name",
                value: themeName || window.mainpage.themeData[0].path,
                onSelect: function (record) {
                    var opts = themeCombo.combobox("options");
                    window.mainpage.setTheme(record[opts.valueField], true);
                }
            });

        $(btnFullScreen).click(function () {
            if ($.util.supportsFullScreen) {
                if ($.util.isFullScreen()) {
                    $.util.cancelFullScreen();
                } else {
                    $.util.requestFullScreen();
                }
            } else {
                $.easyui.messager.show("当前浏览器不支持全屏 API，请更换至最新的 Chrome/Firefox/Safari 浏览器或通过 F11 快捷键进行操作。");
            }
        });

        
    };

    window.mainpage.search = function (value, name) { $.easyui.messager.show($.string.format("您设置的主题为：value: {0}, name: {1}", value, name)); };


    window.mainpage.themeData = $.array.filter($.easyui.theme.dataSource, function (val) {
        return val.disabled ? false : true;
    });

    //  设置当前系统主界面的界面皮肤风格；该方法提供如下参数：
    //      theme:      界面皮肤风格名称
    //      setCookie:  可选参数，boolean 类型，表示是否将 theme 保存至 cookie 名为 themeName
    window.mainpage.setTheme = function (theme, setCookie) {
        if (setCookie == null || setCookie == undefined) { setCookie = true; }
        $.easyui.theme(true, theme, function (item) {
            if (setCookie) {
                $.cookie("themeName", theme, { expires: 30 });
                //修改主题成功后提示信息
                //var msg = $.string.format("您设置了新的系统主题皮肤为：{0}，{1}。", item.name, item.path);
                //$.easyui.messager.show(msg);
            }
        });
    };

    window.mainpage.bindMainTabsButtonEvent = function () {
        $("#mainTabs_jumpHome").click(function () { window.mainpage.mainTabs.jumpHome(); });
        $("#mainTabs_toggleAll").click(function () { window.mainpage.togglePanels(); });
        $("#mainTabs_jumpTab").click(function () { window.mainpage.mainTabs.jumpTab(); });
        $("#mainTabs_closeTab").click(function () { window.mainpage.mainTabs.closeCurrentTab(); });
        $("#mainTabs_closeOther").click(function () { window.mainpage.mainTabs.closeOtherTabs(); });
        $("#mainTabs_closeLeft").click(function () { window.mainpage.mainTabs.closeLeftTabs(); });
        $("#mainTabs_closeRight").click(function () { window.mainpage.mainTabs.closeRightTabs(); });
        $("#mainTabs_closeAll").click(function () { window.mainpage.mainTabs.closeAllTabs(); });
    };

    window.mainpage.bindNavTabsButtonEvent = function () {
        $("#navMenu_refresh").click(function () { window.mainpage.refreshNavTab(); });

        $("#navMenu_Favo").click(function () { window.mainpage.nav.addFavo(); });
        $("#navMenu_Rename").click(function () { window.mainpage.nav.rename(); });
        $("#navMenu_expand").click(function () { window.mainpage.nav.expand(); });
        $("#navMenu_collapse").click(function () { window.mainpage.nav.collapse(); });
        $("#navMenu_collapseCurrentAll").click(function () { window.mainpage.nav.expandCurrentAll(); });
        $("#navMenu_expandCurrentAll").click(function () { window.mainpage.nav.collapseCurrentAll(); });
        $("#navMenu_collapseAll").click(function () { window.mainpage.nav.expandAll(); });
        $("#navMenu_expandAll").click(function () { window.mainpage.nav.collapseAll(); });

        $("#favoMenu_Favo").click(function () { window.mainpage.favo.removeFavo(); });
        $("#favoMenu_Rename").click(function () { window.mainpage.favo.rename(); });
        $("#favoMenu_expand").click(function () { window.mainpage.favo.expand(); });
        $("#favoMenu_collapse").click(function () { window.mainpage.favo.collapse(); });
        $("#favoMenu_collapseCurrentAll").click(function () { window.mainpage.favo.expandCurrentAll(); });
        $("#favoMenu_expandCurrentAll").click(function () { window.mainpage.favo.collapseCurrentAll(); });
        $("#favoMenu_collapseAll").click(function () { window.mainpage.favo.expandAll(); });
        $("#favoMenu_expandAll").click(function () { window.mainpage.favo.collapseAll(); });
    };

    window.mainpage.hideNorth = function () { $(mainLayout).layout("collapse", "north"); };

    window.mainpage.showNorth = function () { $(mainLayout).layout("expand", "north"); };

    window.mainpage.togglePanels = function () { $(mainLayout).layout("toggleAll", "collapse"); };

    window.mainpage.addModuleTab = function (node) {
        var n = node || {}, attrs = node.attributes || {}, opts = $.extend({}, n, { title: n.text }, attrs);
        if (!opts.href) { return; }
        opts.href="../../"+opts.href;
        window.mainpage.mainTabs.addModule(opts);
    };

    //  判断指定的选项卡是否存在于当前主页面的选项卡组中；
    //  返回值：返回的值可能是以下几种：
    //      0:  表示不存在于当前选项卡组中；
    //      1:  表示仅 title 值存在于当前选项卡组中；
    //      2:  表示 title 和 href 都存在于当前选项卡组中；
    window.mainpage.mainTabs.isExists = function (title, href) {
        var t = $(mainTabs), tabs = t.tabs("tabs"), array = $.array.map(tabs, function (val) { return val.panel("options"); }),
            list = $.array.filter(array, function (val) { return val.title == title; }), ret = list.length ? 1 : 0;
        if (ret && $.array.some(list, function (val) { return val.href == href; })) { ret = 2; }
        return ret;
    };

    window.mainpage.mainTabs.tabDefaultOption = {
        title: "新建选项卡", href: "", iniframe: true, closable: true, refreshable: true, iconCls: "icon-standard-application-form", repeatable: true, selected: true
    };
    window.mainpage.mainTabs.parseCreateTabArgs = function (args) {
        var ret = {};
        if (!args || !args.length) {
            $.extend(ret, window.mainpage.mainTabs.tabDefaultOption);
        } else if (args.length == 1) {
            $.extend(ret, window.mainpage.mainTabs.tabDefaultOption, typeof args[0] == "object" ? args[0] : { href: args[0] });
        } else if (args.length == 2) {
            $.extend(ret, window.mainpage.mainTabs.tabDefaultOption, { title: args[0], href: args[1] });
        } else if (args.length == 3) {
            $.extend(ret, window.mainpage.mainTabs.tabDefaultOption, { title: args[0], href: args[1], iconCls: args[2] });
        } else if (args.length == 4) {
            $.extend(ret, window.mainpage.mainTabs.tabDefaultOption, { title: args[0], href: args[1], iconCls: args[2], iniframe: args[3] });
        } else if (args.length == 5) {
            $.extend(ret, window.mainpage.mainTabs.tabDefaultOption, { title: args[0], href: args[1], iconCls: args[2], iniframe: args[3], closable: args[4] });
        } else if (args.length == 6) {
            $.extend(ret, window.mainpage.mainTabs.tabDefaultOption, { title: args[0], href: args[1], iconCls: args[2], iniframe: args[3], closable: args[4], refreshable: args[5] });
        } else if (args.length >= 7) {
            $.extend(ret, window.mainpage.mainTabs.tabDefaultOption, { title: args[0], href: args[1], iconCls: args[2], iniframe: args[3], closable: args[4], refreshable: args[5], selected: args[6] });
        }
        return ret;
    };

    window.mainpage.mainTabs.createTab = function (title, href, iconCls, iniframe, closable, refreshable, selected) {
        var t = $(mainTabs), i = 0, opts = window.mainpage.mainTabs.parseCreateTabArgs(arguments);
        while (t.tabs("getTab", opts.title + (i ? String(i) : ""))) { i++; }
        t.tabs("add", opts);
    };

    //  添加一个新的模块选项卡；该方法重载方式如下：
    //      function (tabOption)
    //      function (href)
    //      function (title, href)
    //      function (title, href, iconCls)
    //      function (title, href, iconCls, iniframe)
    //      function (title, href, iconCls, iniframe, closable)
    //      function (title, href, iconCls, iniframe, closable, refreshable)
    //      function (title, href, iconCls, iniframe, closable, refreshable, selected)
    window.mainpage.mainTabs.addModule = function (title, href, iconCls, iniframe, closable, refreshable, selected) {
        var opts = window.mainpage.mainTabs.parseCreateTabArgs(arguments), isExists = window.mainpage.mainTabs.isExists(opts.title, opts.href);
        switch (isExists) {
            case 0: window.mainpage.mainTabs.createTab(opts); break;
            case 1: window.mainpage.mainTabs.createTab(opts); break;
            case 2: window.mainpage.mainTabs.jumeTab(opts.title); break;
            default: break;
        }
    };

    window.mainpage.mainTabs.jumeTab = function (which) { $(mainTabs).tabs("select", which); };

    window.mainpage.mainTabs.jumpHome = function () {
        var t = $(mainTabs), tabs = t.tabs("tabs"), panel = $.array.first(tabs, function (val) {
            var opts = val.panel("options");
            return opts.title == homePageTitle && opts.href == homePageHref;
        });
        if (panel && panel.length) {
            var index = t.tabs("getTabIndex", panel);
            t.tabs("select", index);
        }
    };

    window.mainpage.mainTabs.jumpTab = function (which) { $(mainTabs).tabs("jumpTab", which); };

    window.mainpage.mainTabs.closeTab = function (which) { $(mainTabs).tabs("close", which); };

    window.mainpage.mainTabs.closeCurrentTab = function () {
        var t = $(mainTabs), index = t.tabs("getSelectedIndex");
        return t.tabs("closeClosable", index);
    };

    window.mainpage.mainTabs.closeOtherTabs = function (index) {
        var t = $(mainTabs);
        if (index == null || index == undefined) { index = t.tabs("getSelectedIndex"); }
        return t.tabs("closeOtherClosable", index);
    };

    window.mainpage.mainTabs.closeLeftTabs = function (index) {
        var t = $(mainTabs);
        if (index == null || index == undefined) { index = t.tabs("getSelectedIndex"); }
        return t.tabs("closeLeftClosable", index);
    };

    window.mainpage.mainTabs.closeRightTabs = function (index) {
        var t = $(mainTabs);
        if (index == null || index == undefined) { index = t.tabs("getSelectedIndex"); }
        return t.tabs("closeRightClosable", index);
    };

    window.mainpage.mainTabs.closeAllTabs = function () {
        return $(mainTabs).tabs("closeAllClosable");
    };

    window.mainpage.mainTabs.updateHash = function (index) {
        var opts = $(mainTabs).tabs("getTab", index).panel("options");
        window.location.hash = opts.href ? opts.href : "";
    };

    window.mainpage.mainTabs.loadHash = function (hash) {
        /*while (hash.left(1) == "#") { hash = hash.substr(1); }
        if (String.isNullOrWhiteSpace(hash)) { return; }
        $.get("common/nav-api-menu-data.json", function (menus) {
            var array = $.fn.tree.extensions.cascadeToArray(menus),
                node = $.array.first(array, function (val) { return val.attributes && val.attributes.href == hash; });
            if (node) {
                window.mainpage.addModuleTab(node);
            } else {
                $.easyui.messager.show("hash is not exists");
            }
        }, "json");*/
    };


    window.mainpage.refreshNavTab = function (index) {
        var t = $(navTabs);
        if (index == null || index == undefined) { index = t.tabs("getSelectedIndex"); }
        if (index == 0) {
            window.mainpage.nav.refreshNav();
        } else {
            window.mainpage.favo.refreshTree();
        }
    };




    window.mainpage.nav.refreshNav = function () { window.mainpage.instMainMenus(); };

    window.mainpage.nav.refreshTree = function () {
       // var menu = $(navMenuList).find("a.tree-node-selected.selected"), item = $.data(menu[0], "menu-item");
        if (item && item.id) { window.mainpage.loadMenu(item.id); }
    };
    /**
     * 添加到收藏
     */
    window.mainpage.nav.addFavo = function (id) {
        var t = $(navMenuTree), node = arguments.length ? t.tree("find", id) : t.tree("getSelected");
        if (!node) { 
        	return $.easyui.messager.show("请先选择一个菜单"); 
        }else{
        var	nodeid= $(navMenuTree).tree("getSelected").id;
      
        $.post($.basePath+"/pms/sys/scj/saveFivo.do",{"rid":nodeid},function(json){
        	 if(json.success){        		 
        		 window.mainpage.loadFavoMenus();
             	return $.easyui.messager.show(json.msg);
             }else{
            	return $.easyui.messager.show(json.msg);
             }
        },"Json");  
       
        	
        }
    };
    /**
     * 重命名
     */
    window.mainpage.nav.rename = function (id, text) {
        var t = $(navMenuTree), node;
        if (!arguments.length) {
            node = t.tree("getSelected");
            if (!node) { return $.easyui.messager.show("请先选择一行数据"); }
            t.tree("beginEdit", node.target);
        } else { }
    };
    /**
     * 展开
     */
    window.mainpage.nav.expand = function (id) {
        var t = $(navMenuTree), node;
        if (id == null || id == undefined) {
            node = t.tree("getSelected");
            if (!node) { return $.easyui.messager.show("请先选择一行数据"); }
        } else {
            node = t.tree("find", id);
            if (!node) { return $.easyui.messager.show("请传入有效的参数 id(菜单标识号)"); }
        }
        t.tree("expand", node.target);
    };
    /**
     * 折叠
     */
    window.mainpage.nav.collapse = function (id) {
        var t = $(navMenuTree), node;
        if (id == null || id == undefined) {
            node = t.tree("getSelected");
            if (!node) { return $.easyui.messager.show("请先选择一行数据"); }
        } else {
            node = t.tree("find", id);
            if (!node) { return $.easyui.messager.show("请传入有效的参数 id(菜单标识号)"); }
        }
        t.tree("collapse", node.target);
    };
    /**
     * 展开当前
     */
    window.mainpage.nav.expandCurrentAll = function (id) {
        var t = $(navMenuTree), node;
        if (id == null || id == undefined) {
            node = t.tree("getSelected");
            if (!node) { return $.easyui.messager.show("请先选择一行数据"); }
        } else {
            node = t.tree("find", id);
            if (!node) { return $.easyui.messager.show("请传入有效的参数 id(菜单标识号)"); }
        }
        t.tree("expandAll", node.target);
    };
    /**
     * 折叠当前
     */
    window.mainpage.nav.collapseCurrentAll = function (id) {
        var t = $(navMenuTree), node;
        if (id == null || id == undefined) {
            node = t.tree("getSelected");
            if (!node) { return $.easyui.messager.show("请先选择一行数据"); }
        } else {
            node = t.tree("find", id);
            if (!node) { return $.easyui.messager.show("请传入有效的参数 id(菜单标识号)"); }
        }
        t.tree("collapseAll", node.target);
    };
    
    window.mainpage.nav.expandAll = function () { $(navMenuTree).tree("expandAll"); };

    window.mainpage.nav.collapseAll = function () { $(navMenuTree).tree("collapseAll"); };


    window.mainpage.favo.refreshTree = function () { window.mainpage.loadFavoMenus(); };
    /**
     * 取消收藏业务
     */
    window.mainpage.favo.removeFavo = function (id) {
        var t = $(favoMenuTree), node = arguments.length ? t.tree("find", id) : t.tree("getSelected");
        if (!node) { 
        	return $.easyui.messager.show("请先选择一条收藏"); 
        }else{
        	var nodeid=node.id;
        	$.post($.basePath+"/pms/sys/scj/deleteFivo.do",{"rid":nodeid},function(json){
        		if(json.msg){
        			window.mainpage.loadFavoMenus();
        			return $.easyui.messager.show(json.msg);
        		}else{
        			return $.easyui.messager.show(json.msg);
        		}   		
        	},"json");
        	
        	
        	return $.easyui.messager.show("执行取消收藏业务"+id);
        }
    };
    /**
     * 收藏改名
     */
    window.mainpage.favo.rename = function (id, text) {
        var t = $(favoMenuTree), node;
        if (!arguments.length) {
            node = t.tree("getSelected");
            if (!node) { return $.easyui.messager.show("请先选择一行数据"); }
            t.tree("beginEdit", node.target);
        } else { }
    };

    var folderId = 20;
    window.mainpage.favo.addFolder = function (node) {
        var t = $(favoMenuTree);
        node = node || t.tree("getSelected");
        $.easyui.messager.prompt("请输入添加的目录名称：", function (name) {
            if (name == null || name == undefined) { return; }
            if (String(name).trim() == "") { return $.easyui.messager.show("请输入目录名称！"); }
            if (node) {
                t.tree("insert", { after: node.target, data: { id: folderId++, text: name, iconCls: "icon-hamburg-folder", attributes: { folder: true } } });
            } else {

            }
        });
    };
    
    window.mainpage.favo.expand = function (id) {
        var t = $(favoMenuTree), node;
        if (id == null || id == undefined) {
            node = t.tree("getSelected");
            if (!node) { return $.easyui.messager.show("请先选择一行数据"); }
        } else {
            node = t.tree("find", id);
            if (!node) { return $.easyui.messager.show("请传入有效的参数 id(菜单标识号)"); }
        }
        t.tree("expand", node.target);
    };

    window.mainpage.favo.collapse = function (id) {
        var t = $(favoMenuTree), node;
        if (id == null || id == undefined) {
            node = t.tree("getSelected");
            if (!node) { return $.easyui.messager.show("请先选择一行数据"); }
        } else {
            node = t.tree("find", id);
            if (!node) { return $.easyui.messager.show("请传入有效的参数 id(菜单标识号)"); }
        }
        t.tree("collapse", node.target);
    };

    window.mainpage.favo.expandCurrentAll = function (id) {
        var t = $(favoMenuTree), node;
        if (id == null || id == undefined) {
            node = t.tree("getSelected");
            if (!node) { return $.easyui.messager.show("请先选择一行数据"); }
        } else {
            node = t.tree("find", id);
            if (!node) { return $.easyui.messager.show("请传入有效的参数 id(菜单标识号)"); }
        }
        t.tree("expandAll", node.target);
    };

    window.mainpage.favo.collapseCurrentAll = function (id) {
        var t = $(favoMenuTree), node;
        if (id == null || id == undefined) {
            node = t.tree("getSelected");
            if (!node) { return $.easyui.messager.show("请先选择一行数据"); }
        } else {
            node = t.tree("find", id);
            if (!node) { return $.easyui.messager.show("请传入有效的参数 id(菜单标识号)"); }
        }
        t.tree("collapseAll", node.target);
    };

    window.mainpage.favo.expandAll = function () { $(favoMenuTree).tree("expandAll"); };

    window.mainpage.favo.collapseAll = function () { $(favoMenuTree).tree("collapseAll"); };






    //初始化捐赠数据列表
    $.util.namespace("donate");
    window.donate.reload = function () {
        /*var donatePanel = $("#donatePanel"), donate = $("#donateList").empty();
        $.ajax({
            url: "common/donate-data.json", type: "get", dataType: "json",
            beforeSend: function (XMLHttpRequest) { $.easyui.loading({ locale: donatePanel }); },
            success: function (data, textStatus, XMLHttpRequest) {
                $.each(window.donate.data = data, function (i, item) {
                    var li = $("<li></li>").appendTo(donate);
                    $("<span></span>").addClass("donate-name").text(item.name).appendTo(li);
                    $("<span></span>").addClass("donate-date").text(item.date).appendTo(li);
                    $("<span></span>").text("(").appendTo(li);
                    $("<span></span>").addClass("donate-total").text(item.total).appendTo(li);
                    $("<span></span>").text("元)").appendTo(li);
                });
            },
            complete: function (XMLHttpRequest, textStatus) { $.easyui.loaded(donatePanel); }
        });*/
    };
    
   
    
    //初始化友情链接列表
    $.util.namespace("link");
    window.link.reload = function () {
        var linkPanel = $("#linkPanel"), link = $("#linkList").empty();
        /*$.ajax({
            url: "common/link-data.json", type: "get", dataType: "json",
            beforeSend: function (XMLHttpRequest) { $.easyui.loading({ locale: linkPanel }); },
            success: function (data, textStatus, XMLHttpRequest) {
                $.each(window.link.data = data, function (i, item) {
                    var li = $("<li></li>").appendTo(link);
                    $("<span " + (item.bold ? "style=\"font-weight: bold;\"" : "") + "></span>").text(item.title).appendTo(li);
                    $("<br />").appendTo(li);
                    $("<a target='_blank'></a>").attr("href", item.href).text(item.href).appendTo(li);
                });
            },
            complete: function (XMLHttpRequest, textStatus) { $.easyui.loaded(linkPanel); }
        });*/
    };

})(jQuery);