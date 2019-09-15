using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Field
/// </summary>
public class Field
{
    public Type FieldType { get; set; }
    public string FieldName { get; set; }
    public Field() { }
    public Field(string fieldName, Type fieldType)
    {
        this.FieldName = fieldName;
        this.FieldType = fieldType;
    }
}