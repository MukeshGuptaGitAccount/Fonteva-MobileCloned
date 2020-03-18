public class GuidebookInvitation {

	public String first_name;
	public String last_name;
	public String email;

	public static GuidebookInvitation parse(String json) {
		return (GuidebookInvitation) System.JSON.deserialize(json, GuidebookInvitation.class);
	}
}