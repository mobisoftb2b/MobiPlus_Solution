using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;

/// <summary>
/// Summary description for ConStrings
/// </summary>
public class ConStrings
{
    private static Dictionary<string, string> dicAllConStrings;
    
    public static Dictionary<string, string>DicAllConStrings
    {
        get
        {
            if (dicAllConStrings == null || dicAllConStrings.Keys.Count == 0)
                SetAllConStrings();
            return dicAllConStrings;
        }
        set
        {
            dicAllConStrings = value;
        }
    }
	public ConStrings()
	{
		//
		// TODO: Add constructor logic here
		//
	}
    private static void SetAllConStrings()
    {
        dicAllConStrings = new Dictionary<string,string>();
        //projects
        string[] repositoryProjects = ConfigurationManager.AppSettings.AllKeys
                         .Where(key => key.EndsWith("_WebConnectionString"))
                         .Select(key => key.Replace("_WebConnectionString", ""))
                         .ToArray();

         string[] repositoryConStrings = ConfigurationManager.AppSettings.AllKeys
                         .Where(key => key.EndsWith("_WebConnectionString"))
                         .Select(key => ConfigurationManager.AppSettings[key])
                         .ToArray();

        if (repositoryProjects != null)
        {
            if (repositoryProjects.Length == 1)//only one
            {
                dicAllConStrings.Add(repositoryProjects[0], repositoryConStrings[0]);
            }
            else
            {
                for (int i = 0; i < repositoryProjects.Length; i++)
                {
                    dicAllConStrings.Add(repositoryProjects[i], repositoryConStrings[i]);
                }
            }
        }
        //end projects
        
    }
}