using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.IO;
using System.Security.AccessControl;
using System.Net;

namespace ZipCreator
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                if (args.Length == 2)
                {
                    if (!(Directory.Exists(args[1])))
                    {
                        Directory.CreateDirectory(args[1]);
                    }

                    CreateZip(args[0], args[1]);
                    Console.ReadLine();
                }
                else
                {
                    Console.WriteLine("Must supply two args!!!");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }
        private static void CreateZip(string srcFileName, string resFileName)
        {
           // FileSecurity fSecurity = File.GetAccessControl(resFileName);

            // Add the FileSystemAccessRule to the security settings.
            //fSecurity.AddAccessRule(new FileSystemAccessRule("mobisoft\\gil",
            //    FileSystemRights.ReadData, AccessControlType.Allow));

            // Set the new access settings.
            //File.SetAccessControl(resFileName, fSecurity);

            try
            {
                File.Delete(resFileName);
            }
            catch (Exception ex)
            {
                Console.WriteLine("catch1");
            }
            //File.SetAccessControl(resFileName, fSecurity);

            try
            {
                Resco.IO.Zip.ZipArchive z = new Resco.IO.Zip.ZipArchive(resFileName, Resco.IO.Zip.ZipArchiveMode.Create, FileShare.None);
                 Console.WriteLine("z1");
            z.Add(srcFileName, "", true, null);
            Console.WriteLine("z2");
            z.Close();
            Console.WriteLine("z3");
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                Console.WriteLine("catch2");

               
            }
            
        }
    }
}
