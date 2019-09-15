using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace MobiSoft.Layout.webAPI
{
    public class AuthController : ApiController
    {
        public UserInstance GetUser()
        {
            return new UserInstance
            {
                username = "Andrey",
                image = "http://www.newtonsoft.com/json/help/icons/logo.jpg"
            };
        }
    }

    public class UserInstance
    {
        public string username { get; set; }
        public string image { get; set; }
    }
}
