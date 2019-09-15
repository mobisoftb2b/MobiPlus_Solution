using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MobiPlus.Diplomat.WebAPI
{
    public class DefaultController : Controller
    {
        // GET: Default
        public ActionResult Index()
        {
            if (Request.Cookies["lang"] != null)
            {
                var cookievalue = Request.Cookies["lang"].Value;
                if (cookievalue == "he")
                {
                    return View("rtl");
                }
                else {
                    return View("ltr");
                }
            }
            return View("rtl");

        }
    }
}