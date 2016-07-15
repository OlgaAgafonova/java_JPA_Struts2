<%@ taglib prefix="s" uri="/struts-tags" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Task</title>
    <style>
        table.list {
            border-collapse: collapse;
            width: 40%;
        }

        table.list, table.list td, table.list th {
            border: 1px solid gray;
            padding: 5px;
        }
    </style>

    <link rel="stylesheet" type="text/css" href="http://cdn.datatables.net/1.10.12/css/jquery.dataTables.css">
    <script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
    <script src="http://code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
    <script src="http://cdn.datatables.net/1.10.12/js/jquery.dataTables.js" type="text/javascript"
            charset="utf8"></script>
    <!-- Подключим jQuery UI -->
    <link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css" rel="stylesheet"
          type="text/css"/>
    <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>

    <script>
        var table;
        var dialog;
        var dialogTable;
        var userRoles;
        function deleteUser(userId) {
            jQuery.ajax({
                type: "POST",
                url: "http://localhost:8080/delete",
                data: {"userId": userId},
                success: function () {
                    table._fnAjaxUpdate();
                },
                error: function () {
                    // error handler
                }
            });
        }

        function FormToJson(form) {
            var array = $(form).serializeArray();
            var json = {};
            var roles = {};
            var i = 0;
            $.each(array, function () {
                if (this.name == 'roles.id') {
                    roles[i] = this.value || '';
                    i++;
                }
            });

            $.each(array, function () {
                if (this.name != 'roles.id')
                    json[this.name] = this.value || '';
            });
            json['roles'] = roles;
            return json;
        }

        function addUser() {
            var form = $('#formAddUser');
            var json = FormToJson(form);
            console.log(json);
            jQuery.ajax({
                type: 'post',
                url: "http://localhost:8080/add",
                dataType: 'json',
                data: json,
                traditional: true,
                processData: false,
                success: function () {
                    form[0].reset();
                    table._fnAjaxUpdate();
                }
                ,
                error: function () {
                    // error handler
                }
            });
        }

        function editUserRoles(userId) {
            jQuery.ajax({
                type: 'post',
                url: "http://localhost:8080/get",
                data: {"userId": userId},
                traditional: true,
                cashe: true,
                success: function (data) {
                    userRoles = data;
                    dialogTable._fnAjaxUpdate();
                },
                error: function () {
                    // error handler
                }
            });
            dialogTable.fnUpdate();
            dialog.dialog("open");
        }

        function addDataToTable() {
            $('#editRolesDialog').dialog("close");
        }


        $(document).ready(function () {
            table = $("#jqueryDataTable").dataTable({
                "sPaginationType": "full_numbers",
                "sAjaxSource": "list",
                "bJQueryUI": true,
                "aoColumns": [
                    {"mData": "firstname", sDefaultContent: "n/a"},
                    {"mData": "lastname", sDefaultContent: "n/a"},
                    {"mData": "email", sDefaultContent: "n/a"},
                    {"mData": "login", sDefaultContent: "n/a"},
                    {
                        "mData": "roles", "render": function (data, type, full, meta) {
                        var strRoles = "";
                        for (var i = 0; i < data.length; i++) {
                            strRoles += data[i].name + " ";
                        }
                        return strRoles + " /" + '<a href="#" onclick="editUserRoles(' + full.id + ')">Edit</a>';
                    }, sDefaultContent: "n/a"
                    },
                    {
                        "mData": "id", "render": function (data, type, full, meta) {
                        return '<a href="#" onclick="deleteUser(' + data + ')">Delete</a>';
                    }
                    }
                ]
            });

            dialog = $('#editRolesDialog').dialog({
                buttons: [{text: "OK", click: addDataToTable},
                    {
                        text: "CANCEL", click: function () {
                        $(this).dialog("close")
                    }
                    }],
                modal: true,
                autoOpen: false
            });

            dialogTable = $("#jqueryEditUserRolesTable").dataTable({
                "sPaginationType": "full_numbers",
                "sAjaxSource": "http://localhost:8080/edit/roles",
                "bJQueryUI": true,
                "aoColumns": [
                    {"mData": "name", sDefaultContent: "n/a"},
                    {
                        "mData": "name", "render": function (data, type, full, meta) {
                        var isGranted = false;
                        for (var i = 0; i < userRoles.aaData.length; i++) {
                            if (data == userRoles.aaData[i].name) isGranted = true;
                        }
                        return '<button>' + (isGranted ? 'Delete' : 'Add') + '</button>';

                    }, sDefaultContent: "n/a"
                    }
                ]
            });
        });

    </script>


</head>
<body>

<s:form id="formAddUser">
    <h3>Add user</h3>
    <table>
        <tr>
            <td><s:textfield key="label.firstname" name="firstname" requiredLabel="true"/></td>
        </tr>
        <tr>
            <td><s:textfield key="label.lastname" name="lastname" requiredLabel="true"/></td>
        </tr>
        <tr>
            <td><s:textfield key="label.email" name="email" type="email" requiredLabel="true"/></td>
        </tr>
        <tr>
            <td><s:textfield key="label.login" name="login" requiredLabel="true"/></td>
        </tr>
        <tr>
            <td>
                <select required multiple name="roles.id">
                    <option value="0" disabled>Select user's role</option>
                    <s:iterator value="roles" var="role">
                        <option value="<s:property value="#role.id"/>">
                            <s:property value="#role.name"/>
                        </option>
                    </s:iterator>
                </select>
            </td>
        </tr>

        <tr>
            <td>
                <input type="button" value="Add user" onclick="addUser()"/>
            </td>
        </tr>
    </table>
</s:form>

<div id="container">
    <div id="demo_jui">
        <table class="display" id="jqueryDataTable">
            <thead>
            <tr>
                <th>First name</th>
                <th>Last name</th>
                <th>Email</th>
                <th>Login</th>
                <th>Roles</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>
</div>

<div id="editRolesDialog" title="Edit user's roles">
    Here you can changed user's roles.
    <div id="dialogcontainer">
        <table class="display" id="jqueryEditUserRolesTable">
            <thead>
            <tr>
                <th>Roles</th>
                <th>Select</th>
            </tr>
            </thead>
            <tbody>
            </tbody>
        </table>

    </div>
</div>

</body>
</html>