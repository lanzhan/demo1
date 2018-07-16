<#import "/spring.ftl" as s>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <meta charset="utf-8">
    <title>学生用户列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <#include 'include/baselink.ftl'>
    <link rel="stylesheet" type="text/css" href="<@s.url '/assets/css/jquery.pagination.css'/>">
    <style type="text/css">
        #update-User{
            display: none;
        }
        #insert-User{
            display: none;
        }
    </style>
</head>

<body class="dashboard-page">

<div id="userList">
    <nav style="background-color:#f5f5f5;padding:0 20px;border-bottom:1px solid #e5e5e5;line-height:41px;height:41px;font-size:14px;">
        <span class="glyphicon glyphicon-home"></span> 首页 <span>&gt;</span> 用户管理 <span>&gt;</span> 用户列表
        <a class="btn btn-success btn-sm" href="javascript:location.replace(location.href);" style="float:right; margin-top:5px" title="刷新" >
            <span class="glyphicon glyphicon-refresh"></span>
        </a>
    </nav>


    <div class="container">
        <!-- 标题 -->
        <div class="row">
            <div class="col-md-12">
                <h1>学生信息管理</h1>
            </div>
        </div>
        <!-- 按钮 -->
        <div class="row">
            <div class="col-md-3 col-md-offset-4">
                <div class="input-group">
                    <input type="text" class="form-control" id="user_select_input"
                           placeholder="请输入学生姓名" v-model="searchInfo.name">
                    <span class="input-group-btn">
               		<button class="btn btn-info btn-search" id="user_select_btn" @click="search">查找</button>
                    </span>
                </div>
            </div>
        </div>
        <!-- 表格数据 -->
        <div class="row">
            <div class="col-md-12">
                <table class="table table-hover" id="users_table">
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>用户名</th>
                        <th>年龄</th>
                        <th>电话</th>
                        <th>地址</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr v-for="user in users">
                        <td>{{user.id}}</td>
                        <td>{{user.name}}</td>
                        <td>{{user.age}}</td>
                        <td>{{user.phone}}</td>
                        <td>{{user.address}}</td>
                        <td>
                            <button class="updata_user_btn" class="btn btn-info"
                                    class="btn btn-sm btn-primary">
                                <span class="glyphicon glyphicon-pencil" @click = "updateUser(user)">修改</span>
                            </button>
                            <button class="delete_user_btn" class="btn btn-sm btn-danger">
                                <span class="glyphicon glyphicon-trash" @click ="deleteUser(user)">删除</span>
                            </button>
                        </td>
                    </tr>
                    </tbody>
                    <tfoot>
                    <tr>
                        <td colspan="20">
                            <div class="table-responsive">
                                <div id="pageMenu"></div>
                            </div>
                        </td>
                        <td>
                            <button class="insert_user_btn" @click = "insertUser(user)"
                                    class="btn btn-sm btn-primary">
                                <span class="glyphicon glyphicon-pencil">添加</span>
                            </button>
                        </td>
                    </tr>
                    </tfoot>
                </table>
            </div>
        </div>
        <div id="update-User">
            <h2>修改用户信息</h2>
            <div >
                <tr>
                    <label>姓名：</label>
                    <input type="text"  v-model="updateInfo.name">
                </tr>
                <tr>
                    <label>年龄：</label>
                    <input type="text"  v-model="updateInfo.age">
                </tr>
                <tr>
                    <label>电话：</label>
                    <input type="text"   v-model="updateInfo.phone">
                </tr>
                <tr>
                    <label>地址：</label>
                    <input type="text"   v-model="updateInfo.address">
                </tr>
                <button  v-on:click = "updatedUser()">完成</button>
            </div>
        </div>

        <div id="insert-User">
            <h2>添加用户</h2>
            <div >
                <tr>
                    <label>姓名：</label>
                    <input type="text" v-model="insertInfo.name">
                </tr>
                <tr>
                    <label>年龄：</label>
                    <input type="text" v-model="insertInfo.age">
                </tr>
                <tr>
                    <label>电话：</label>
                    <input type="text"  v-model="insertInfo.phone">
                </tr>
                <tr>
                    <label>地址：</label>
                    <input type="text"  v-model="insertInfo.address">
                </tr>
                <button   v-on:click = "insertedUser()">完成</button>
            </div>
        </div>
    </div>
</div>
<#include 'include/footer_js.ftl'/>
<script src="/assets/js/jquery.pagination-1.2.7.js"></script>
<script>

    var app = new Vue({
        el: '#userList',
        data: {
            users: [],//用户信息
            searchInfo: {//请求参数
                id:'',
                name:'',
                age: '',
                phone:'',
                address:'',
                page: 1,
                pageSize: 10
            },
            insertInfo: {
                id: null,
                name: '',
                age: '',
                phone:'',
                address:''
            },
            updateInfo: {
                id: null,
                name:'',
                age: '',
                phone:'',
                address:''
            }
        },
        created: function () {
            this.searchInfo.page = 1;
            this.search();
        },

        watch:{
            "searchInfo.name":function () {
                this.search();
            }
        },
        methods: {
            search: function () {
                this.searchInfo.page = 1;
                $('#pageMenu').page('destroy');//销毁分页
                this.query();
            },
            insertUser:function(user){
                $("#update-User").css("display","none");
                $("#insert-User").css("display","block");
                    this.insertInfo = {
                        name: user.name,
                        age:user.age,
                        phone:user.phone,
                        address:user.address
                    }
            },
            insertedUser:function(){
                var url = "/api/user/insert";
                this.$http.post(url, this.insertInfo).then(function (response) {
                    sweetAlert("success");
                    this.query();
                }, function (error) {
                    swal(error.body.msg);
                });
            },
            updateUser : function(user){
                $("#update-User").css("display","block");
                $("#insert-User").css("display","none");
                this.updateInfo = {
                    name: user.name,
                    age:user.age,
                    phone:user.phone,
                    address:user.address
                }
            },
            updatedUser : function(){
                var url = "/api/user/update";
                this.$http.post(url, this.updateInfo).then(function (response) {
                    sweetAlert("success");
                    this.query();
                }, function (error) {
                    swal(error.body.msg);
                });
            },

            deleteUser: function (user) {
                var url = "/api/user/delete";
                this.$http.post(url, user).then(function (response) {
                    sweetAlert("success");
                    this.query();
                }, function (error) {
                    swal(error.body.msg);
                });
            },

            query: function () {
                var url = "/api/user/list";
                this.$http.post(url, this.searchInfo).then(function (response) {
                    this.users = response.data.data.list;
                    console.log(this.users)
                    var temp = this;
                    $("#pageMenu").page({//加载分页
                        total: response.data.data.total,
                        pageSize: response.data.data.pageSize,
                        firstBtnText: '首页',
                        lastBtnText: '尾页',
                        prevBtnText: '上一页',
                        nextBtnText: '下一页',
                        showInfo: true,
                        showJump: true,
                        jumpBtnText: '跳转',
                        infoFormat: '{start} ~ {end}条，共{total}条'
                    }, response.data.data.page).on("pageClicked", function (event, pageIndex) {
                        temp.searchInfo.page = pageIndex + 1;
                    }).on('jumpClicked', function (event, pageIndex) {
                        temp.searchInfo.page = pageIndex + 1;
                    });
                }, function (error) {
                    swal(error.body.msg);
                });
            }
        }
    });
    //     watch: {
    //         "searchInfo.page": function () {
    //             this.query();
    //         },
    //         "searchInfo.name": function () {
    //             this.query();
    //         },
    //         "insertInfo.code": function (newCode, oldCode) {
    //             var _self = this;
    //             this.workOrderTypes.forEach(function (item, index) {
    //                 if (item.code == newCode) {
    //                     _self.insertInfo.name = item.value;
    //                     return false;//跳出循环
    //                 }
    //             });
    //         }
    //     },
    //     methods: {
    //         search: function () {
    //             this.searchInfo.page = 1;
    //             $('#pageMenu').page('destroy');//销毁分页
    //             this.query();
    //         },
    //
    //                 query: function () {
    //                     var url = "/api/user/list";
    //                     this.$http.post(url, this.searchInfo).then(function (response) {
    //                         this.users = response.data.data.list;
    //                         console.log(this.users)
    //                         var temp = this;
    //                         $("#pageMenu").page({//加载分页
    //                             total: response.data.data.total,
    //                             pageSize: response.data.data.pageSize,
    //                             firstBtnText: '首页',
    //                             lastBtnText: '尾页',
    //                             prevBtnText: '上一页',
    //                             nextBtnText: '下一页',
    //                             showInfo: true,
    //                             showJump: true,
    //                             jumpBtnText: '跳转',
    //                             infoFormat: '{start} ~ {end}条，共{total}条'
    //                         }, response.data.data.page).on("pageClicked", function (event, pageIndex) {
    //                             temp.searchInfo.page = pageIndex + 1;
    //                         }).on('jumpClicked', function (event, pageIndex) {
    //                             temp.searchInfo.page = pageIndex + 1;
    //                         });
    //                     }, function (error) {
    //                         swal(error.body.msg);
    //                     });
    //                 },
    //
    //
    //         insertUser: function () {
    //             this.operate = 1;
    //             this.insertInfo = {
    //                 name: '',
    //                 gender: '',
    //                 age:'',
    //                 mobile:''
    //             }
    //         },
    //         updateUser: function (order) {
    //             this.operate = 2;
    //             this.updateInfo = {
    //                 id: order.id,
    //                 name: order.name,
    //                 gender:order.gender,
    //                 age:order.age,
    //                 mobile:order.mobile
    //             }
    //         },
    //         save: function () {
    //             var vue = this;
    //             swal({
    //                         title: "确定保存？",
    //                         showCancelButton: true,
    //                         closeOnConfirm: false,
    //                         showLoaderOnConfirm: true
    //                     },
    //                     function () {
    //                         var url;
    //                         if (vue.operate == 1) {
    //                             $("#update-User").css("display","none");
    //                             $("#insert-User").css("display","block");
    //                             url = contentPath + "/api/user/insert";
    //                         } else {
    //                             $("#update-User").css("display","block");
    //                             $("#insert-User").css("display","none");
    //                             url = contentPath + "/api/user/update";
    //                         }
    //                         vue.$http.post(url, vue.insertInfo)
    //                                 .then(function (resp) {
    //                                     if (resp.data.retcode == 2000000) {
    //                                         swal("保存成功！");
    //                                         vue.query();
    //                                     } else {
    //                                         swal(resp.data.msg);
    //                                     }
    //                                 }, function (error) {
    //                                     swal(error.data.msg);
    //                                 });
    //                     }
    //             );
    //         },
    //         delete: function (id) {
    //             var vue = this;
    //             swal({
    //                         title: "确定删除？",
    //                         showCancelButton: true,
    //                         closeOnConfirm: false,
    //                         showLoaderOnConfirm: true
    //                     },
    //                     function () {
    //                         var url = contentPath + "/api/user/delete/" + id;
    //                         vue.$http.post(url)
    //                                 .then(function (resp) {
    //                                     if (resp.data.retcode == 2000000) {
    //                                         swal("删除成功");
    //                                         vue.query();
    //                                     } else {
    //                                         swal(resp.data.msg);
    //                                     }
    //                                 }, function (error) {
    //                                     swal(error.data.msg);
    //                                 });
    //                     }
    //             );
    //         },
    //
    //         saveupdateInfo: function () {
    //             var url = contentPath + "/api/user/update"
    //             var vue = this;
    //             this.$http.post(url, vue.updateInfo)
    //                     .then(function (resp) {
    //                         if (resp.data.retcode == 2000000) {
    //                             $("#update-User").modal('hide');
    //                             vue.query();
    //                         } else {
    //                             swal(resp.data.msg);
    //                         }
    //                     }, function (error) {
    //                         swal(error.data.msg);
    //                     });
    //         }
    //
    //     }
    // });
</script>
</body>
</html>
