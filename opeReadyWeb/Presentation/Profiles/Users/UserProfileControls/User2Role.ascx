<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="User2Role.ascx.cs" Inherits="PQ.Admin.Presentation.Profiles.Users.UserProfileControls.User2Roles" %>
<div class="emplSearch">
    <fieldset>
        <legend>
            <asp:Label runat="server" ID="Label1" Text="<%$ Resources:Profile, User2Role_headerUser2Role %>" /></legend>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <asp:RadioButtonList runat="server" DataTextField="Role_ORGName" ClientIDMode="Static"
                        CssClass="checkbox inline checkboxinline" 
                        RepeatDirection="Vertical" DataValueField="Role_ID" ID="cblUser2Role">
                    </asp:RadioButtonList>
                </p>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <input id="btnSaveUser2Role" type="button" class="button" clientidmode="Static" runat="server"
                            value="<%$ Resources:Profile, UserProfile_btnUpdate %>" onclick="btnSaveUser2Role_Click();" />
                    </p>
                </div>
            </div>
        </div>
    </fieldset>
</div>
<script type="text/javascript">
    function btnSaveUser2Role_Click() {
        var params = getArgs();
        var values = new Array();
        var count = 0;
        $("#waitplease").css({ 'display': 'block' });
        $("#cblUser2Role input[type=radio]:checked").each(function () {
            var currentValue = $(this).parent().attr('someValue');
            if (currentValue != '')
                values[count] = currentValue;
            count++;
        });
        profile.SaveUser2RoleID(values, params.usid);
    }
</script>
