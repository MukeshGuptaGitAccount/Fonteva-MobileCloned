public class GuidebookCustomListItem {
    
	public integer id;
	public String import_id;
	public Integer guide;
	public String description_html;
	public String name;
    public String subtitle;

	
	public static GuidebookCustomListItem parse(String json) {
		return (GuidebookCustomListItem) System.JSON.deserialize(json, GuidebookCustomListItem.class);
	}
}