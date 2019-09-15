<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="User2Unit.ascx.cs" Inherits="PQ.Admin.Presentation.Profiles.Users.UserProfileControls.User2Unit" %>
<div class="emplSearch">
    <div class="div_wrapper treeUnitsEdit">
        <p>
            <label class="label">
                <asp:Label runat="server" ID="lblUnit" Text="<%$ Resources:Employee, EmpSearch_lblUnit %>" /></label>
            <div id="UnitsTree">
            </div>
        </p>
    </div>
    <div class="div_wrapper reloadImage" title="Refresh" id="imgReload">
        &nbsp;
    </div>
</div>
<div class="emplSearch">
    <div class="div_wrapper">
        <p>
            <input id="btnSaveUser2Unit" type="button" class="button" clientidmode="Static" runat="server"
                value="<%$ Resources:Profile, UserProfile_btnUpdate %>" />
        </p>
    </div>
</div>
<script type="text/javascript">
    $(function (e) {
        setTimeout(function () { profile.CreateUnitTree(); }, 500);
    });
    $("#btnSaveUser2Unit").live("click", function (e) {
        e.preventDefault();
        var params = getArgs();
        var values = new Array();
        $("#waitplease").css({ 'display': 'block' });
        $(".jstree-checked").each(function () {
            values.push(this.id);
        });
        profile.SaveUser2UnitsID(values, params.usid);
    });

    $("#imgReload").live("click", function (e) {
        e.preventDefault();
        $.ajaxSetup({ cache: false });
        $("#waitplease").css({ 'display': 'block' });
        profile.CreateUnitTree();
        var tree = jQuery.jstree._reference("#UnitsTree");
        var currentNode = tree._get_node(null, false);
        var parentNode = tree._get_parent(currentNode);
        tree.refresh(parentNode);
        tree.open_all(-1, true);
        //setInterval(function () { $("#waitplease").css({ 'display': 'none' }); }, 250);
    });
    
         
</script>
