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
public class GuidebookAttendee {

	public Integer id;
	public Integer guide;
    public Integer guide_id;
	public Integer account_id;
	public String import_id;
	public String first_name;
	public String last_name;
	public String email;
	public Object avatar;
	public Object cover;
	public App_profile app_profile;
	public Boolean revoked;
	public Integer status;
	public Object last_email_send;

	public class App_profile {
		public String website;
		public String position;
		public String company;
		public String contact_email;
	}

	
	public static GuidebookAttendee parse(String json) {
		return (GuidebookAttendee) System.JSON.deserialize(json, GuidebookAttendee.class);
	}
}