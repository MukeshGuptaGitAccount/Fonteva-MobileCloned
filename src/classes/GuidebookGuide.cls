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
public class GuidebookGuide {

	public Integer id;
	public String name;
	public String description_html;
	public Object attendees_estimate;
	public datetime start_date;
	public datetime end_date;
	public String timezone;
	public datetime created_at;

	
	public static GuidebookGuide parse(String json) {
		return (GuidebookGuide) System.JSON.deserialize(json, GuidebookGuide.class);
	}
}