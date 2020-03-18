public class GuidebookMenuItem {
    
    public Integer id;
	public String content_type;
	public Integer guide;
	public Integer object_id;
	public Boolean enabled;
	public String created_at;

	
	public static GuidebookSpeaker parse(String json) {
		return (GuidebookSpeaker) System.JSON.deserialize(json, GuidebookSpeaker.class);
	}
}