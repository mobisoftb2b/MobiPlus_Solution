<%@ Page Language="C#" AutoEventWireup="true" CodeFile="testColSpanRowSapn.aspx.cs"
    Inherits="tests_testColSpanRowSapn" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table border="1" width="300px" style="text-align: center;">
            <tr>
                <td rowspan="2">
                    1
                </td>
                <td colspan="2">
                    2
                </td>
            </tr>
            <tr>
                <td>
                    3
                </td>
                <td>
                    4
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    5
                </td>
                
            </tr>
        </table>
        <br />
        <br />
        <table border="2" cellpadding="4">
            <tr>
                <th rowspan="3" bgcolor="#99CCFF">
                    Production
                </th>
                <td>
                    Raha Mutisya
                </td>
                <td>
                    1493
                </td>
            </tr>
            <tr>
                <td>
                    Shalom Buraka
                </td>
                <td>
                    3829
                </td>
            </tr>
            <tr>
                <td>
                    Brandy Davis
                </td>
                <td>
                    0283
                </td>
            </tr>
            <tr>
                <th rowspan="3" bgcolor="#99CCFF">
                    Sales
                </th>
                <td>
                    Claire Horne
                </td>
                <td>
                    4827
                </td>
            </tr>
            <tr>
                <td>
                    Bruce Eckel
                </td>
                <td>
                    7246
                </td>
            </tr>
            <tr>
                <td>
                    Danny Zeman
                </td>
                <td>
                    5689
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
