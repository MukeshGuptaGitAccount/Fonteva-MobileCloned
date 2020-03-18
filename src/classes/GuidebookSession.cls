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
public class GuidebookSession {
    public Integer id;
    public String created_at;
    public datetime start_time;
    public datetime end_time;
    public Boolean all_day;
    public String name;
    public String description_html;
    public String import_id;
    public Boolean allow_rating;
    public Boolean add_to_schedule;
    public Integer guide;
    public List<decimal> schedule_tracks;
    public Object image;
    public List<decimal> locations;

    public static GuidebookSession parse(String json) {
        return (GuidebookSession) System.JSON.deserialize(json, GuidebookSession.class);
    }
}