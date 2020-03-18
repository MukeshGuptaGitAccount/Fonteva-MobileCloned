public class GuidebookCustomListItemRelation {

	public Integer custom_list;
	public Integer custom_list_item;
	public Double rank;

	
	public static GuidebookCustomListItemRelation parse(String json) {
		return (GuidebookCustomListItemRelation) System.JSON.deserialize(json, GuidebookCustomListItemRelation.class);
	}
}