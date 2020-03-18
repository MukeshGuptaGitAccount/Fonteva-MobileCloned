/*
 * -----------------------------------------------------------------------------
 * COPYRIGHT (C) 2019, FONTEVA, INC.
 * ALL RIGHTS RESERVED.
 *
 * ALL INFORMATION CONTAINED HEREIN IS, AND REMAINS THE PROPERTY OF FONTEVA
 * INCORPORATED AND ITS SUPPLIERS, IF ANY. THE INTELLECTUAL AND TECHNICAL
 * CONCEPTS CONTAINED HEREIN ARE PROPRIETARY TO FONTEVA INCORPORATED AND
 * ITS SUPPLIERS AND MAY BE COVERED BY U.S. AND FOREIGN PATENTS, PATENTS IN
 * PROCESS, AND ARE PROTECTED BY TRADE SECRET OR COPYRIGHT LAW. DISSEMINATION
 * OF THIS INFORMATION OR REPRODUCTION OF THIS MATERIAL IS STRICTLY FORBIDDEN
 * UNLESS PRIOR WRITTEN PERMISSION IS OBTAINED FROM FONTEVA, INC.
 * -----------------------------------------------------------------------------
 */
public class GuidebookMainVenue {

	public Integer id;
	public Integer guide;
	public String name;
	public string description;
	public Decimal latitude;
	public Decimal longitude;
    public Integer location_type;
	public string import_id;
    public String created_at;
	public Address address;

	public class Address {
		public String city;
		public String country;
		public String zipcode;
		public String state;
		public String street;
        public String address;
	}

	
	public static GuidebookMainVenue parse(String json) {
		return (GuidebookMainVenue) System.JSON.deserialize(json, GuidebookMainVenue.class);
	}
}