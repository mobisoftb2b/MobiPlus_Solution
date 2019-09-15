<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="User2Job.ascx.cs" Inherits="PQ.Admin.Presentation.Profiles.Users.UserProfileControls.User2Jobs" %>
<div class="emplSearch">
    <fieldset>
        <legend>
            <asp:Label runat="server" ID="Label17" Text="<%$ Resources:Profile, User2Job_headerUser2Job %>" /></legend>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <asp:CheckBoxList runat="server" DataTextField="Job_Name" ClientIDMode="Static" CssClass="checkbox inline checkboxinline"
                        RepeatLayout="Table" RepeatColumns="3" RepeatDirection="Vertical" DataValueField="Job_ID"
                        ID="cblJobsList">
                    </asp:CheckBoxList>
                </p>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <input id="btnSaveUser2Job" type="button" class="button" clientidmode="Static" runat="server"
                            value="<%$ Resources:Profile, UserProfile_btnUpdate %>" onclick="btnSaveUser2Job_Click();" />
                    </p>
                </div>
            </div>
        </div>
    </fieldset>
</div>
<script type="text/javascript">
function btnSaveUser2Job_Click() {
        var params = getArgs();
        var values = new Array();
        var count = 0;
        $("#waitplease").css({ 'display': 'block' });
        $("#cblJobsList input[type=checkbox]:checked").each(function () {
            var currentValue = $(this).parent().attr('someValue');
            if (currentValue != '')
                values[count] = currentValue;
            count++;
        });
        profile.SaveUser2JobID(values, params.usid);
    }
</script> 