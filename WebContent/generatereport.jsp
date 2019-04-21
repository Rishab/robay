<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<title>roBay: Sales Report</title>
<link rel="stylesheet" href="css/main.css">
</head>
<body>
	<%!	
		private class TopsNode implements Comparable<TopsNode> {
			float sales;
			String name;
			String id;
			
			private TopsNode(float sales, String name, String id) {
				this.sales = sales;
				this.name = name;
				this.id = id;
			}
			
			@Override
		    public int compareTo(TopsNode other) {
				if (this.sales > other.sales) {
					return 1;
				} else if (this.sales == other.sales) {
					return 0;
				} else {
					return -1;
				}
		    }
		}
		
		private boolean readBox(String response) {
			
			if (response == null) {
				return false;
			}
			
			return true;
		}
	
		private String getLastString(ResultSet set) {
		
			if (set == null) {
				return null;
			}
			
			String result = "null";
			
			try {
				int num_cols = set.getMetaData().getColumnCount();
				
				while (set.next()) {
					for (int i = 1; i <= num_cols; i++) {
					    result = set.getString(i);
					}
				}
				
			} catch (Exception e) {
				//e.printStackTrace();
			}
			
			return result;
		}
	
		private ResultSet runQuery(String query, Connection con) {
			
			ResultSet set = null;
			try {
				Statement stmt = con.createStatement();
				set = stmt.executeQuery(query);
				
			} catch(Exception e) {
				//e.printStackTrace();
			}
			
			return set;
		}
	%>
	<header>
	<div class="left-float">
		<b><em>roBay</em></b>, by Group 18
	</div>
	<div class="right-text">
		<a href="landingPage.jsp" class="capitalize padding-right-tiny decoration-hover visited-navy color-navy">Home</a>
		
		<%
			String acc_type = (String) session.getAttribute("acc_type");
			boolean admin = false;
			boolean staff = false;
			if (acc_type == null) {
				%>
					<a href="login.jsp" class="capitalize padding-right-tiny decoration-hover visited-navy color-navy">Log in</a>
				<%
			} else {
				if (acc_type.equals("A")) {
					admin = true;
				} else if (acc_type.equals("S")) {
					staff = true;
				}
				%>
					<a href="logOut.jsp" class="capitalize padding-right-tiny decoration-hover visited-navy color-navy">Logout</a>
				<%
			}
			
		%>
	</div>
	<hr>
</header>
	<%
		if (admin) {
			// This assumes session is secured by the server and can't be fudged by an end user...
			
			boolean item, type, user, best_items, best_users;
			boolean invalid_threshold = false;
			int tops_threshold = 5;
			item = readBox(request.getParameter("item"));
			type = readBox(request.getParameter("type"));
			user = readBox(request.getParameter("user"));
			best_items = readBox(request.getParameter("best_items"));
			best_users = readBox(request.getParameter("best_users"));
			ArrayList<TopsNode> top_items = new ArrayList<TopsNode>();
			ArrayList<TopsNode> top_users = new ArrayList<TopsNode>();
			
			String tops_threshold_str = request.getParameter("num_tops");
			
			try {
				tops_threshold = Integer.parseInt(tops_threshold_str);
				
				if (tops_threshold <= 0 || tops_threshold > 1000) {
					tops_threshold = 5;
					invalid_threshold = true;
				}
			} catch (NumberFormatException e) {
				invalid_threshold = true;
			}
            
            try {
            	
    			String url = "jdbc:mysql://db-project.cvdxoiqfbf2x.us-east-2.rds.amazonaws.com:3306/RobayProjectSchema";
    			Class.forName("com.mysql.jdbc.Driver");

    			Connection con = DriverManager.getConnection(url, "sqlgroup", "be_my_robae");
    			if (con != null) {
    				// System.out.println("Successfully connected to the database.");
    			} else {
    				System.out.println("Failed to connect to the database.");
    			}

    			String dateresult = getLastString(runQuery("SELECT NOW()", con));
				
				%>
				    <div class="center-text margin-up color-brown">
				        <h2>
				            <em>roBay</em> Sales Report<%=" for " + dateresult%>
				        </h2>
				    </div>
				    <div class="height-tiny"></div>
				
				    <div class="center width-most width-capped-decent card-box debug" style="padding: 10px 10px 10px 10px;">
				    	<h2>Earnings</h2>
				    	
				    	<%
				    	 	String total_earnings_str = getLastString(runQuery("SELECT SUM(max_bid_amt) FROM Auction WHERE status='closed';", con));
					    	float total_earnings = 0;
					    	
					    	if (total_earnings_str != null) {
					    		total_earnings = Float.parseFloat(total_earnings_str);
					    	}
				    	%>
				    	
				    	<table class="earnings-table width-full">
							<tr>
								<td class="left-text">
									<em>Total</em>
								</td>
								<td class="right-text">
									<em>$</em> <%=total_earnings%>
								</td>
							</tr>
						</table>
				    	
						<%
							if (item || type || user || best_items) {
								if (item || type || user) {
									%>
										<hr>
										<h2>Sorted by</h2>
									<%
								}
										if (item || best_items) {		
											if (item) {
												%>
													<h3><em>Items Sold</em></h3>
													<table class="earnings-table width-full">
												<%
											}
											
											ResultSet by_items = runQuery("SELECT * FROM Auction WHERE status='closed';", con);
											
											try {
												
												while (by_items.next()) {
												    String listing_name = by_items.getString(4);
												    String robot_id = by_items.getString(7);
												    String winning_bid_str = by_items.getString(6);
												    float winning_bid = 0;
												    if (winning_bid_str != null) {
												    	winning_bid = Float.parseFloat(winning_bid_str);
												    }
												    
												    top_items.add(new TopsNode(winning_bid, listing_name, robot_id));
												    
												    if (item) {
													    %>									
															<tr>
																<td class="left-text">
																	<em><%=listing_name%></em><%=" (Robot ID: " + robot_id + ")"%>
																</td>
																<td class="right-text">
																	<em>$</em> <%=winning_bid%>
																</td>
															</tr>												    
													    <%
												    }
												}
											
											} catch (Exception e) {
												e.printStackTrace();
											}
											
											if (item) {
												%>
													</table>
												<%
											}
										}
									
										if (type) {
											%>
												<h3><em>Type of Item</em></h3>
												<table class="earnings-table width-full">
											<%
											float total_personal = 0;
											ResultSet ids = runQuery("SELECT robot_id From Robot WHERE r_type='personal';", con);
											
											try {
											
												while (ids.next()) {
												    int robot_id = ids.getInt(1);

												    String winning_bid_str = getLastString(runQuery("SELECT max_bid_amt From Auction WHERE robot_id=" + robot_id + " AND status='closed';", con));
												    
												    if (winning_bid_str == null || winning_bid_str.equalsIgnoreCase("null")) {
												    	continue;
												    }
												    float winning_bid = Float.parseFloat(winning_bid_str);
												    total_personal += winning_bid;
												}
											
											} catch (Exception e) {
												e.printStackTrace();
											}
											
										    %>									
													<tr>
														<td class="left-text">
															<em>personal</em>
														</td>
														<td class="right-text">
															<em>$</em> <%=total_personal%>
														</td>
													</tr>
											<%
											
											float total_medical = 0;
											ids = runQuery("SELECT robot_id From Robot WHERE r_type='medical';", con);
											
											try {
											
												while (ids.next()) {
												    int robot_id = ids.getInt(1);

												    String winning_bid_str = getLastString(runQuery("SELECT max_bid_amt From Auction WHERE robot_id=" + robot_id + " AND status='closed';", con));
												    
												    if (winning_bid_str == null || winning_bid_str.equalsIgnoreCase("null")) {
												    	continue;
												    }
												    float winning_bid = Float.parseFloat(winning_bid_str);
												    total_medical += winning_bid;
												}
											
											} catch (Exception e) {
												e.printStackTrace();
											}
											
										    %>									
													<tr>
														<td class="left-text">
															<em>medical</em>
														</td>
														<td class="right-text">
															<em>$</em> <%=total_medical%>
														</td>
													</tr>
											<%
											
											float total_military = 0;
											ids = runQuery("SELECT robot_id From Robot WHERE r_type='military';", con);
											
											try {
											
												while (ids.next()) {
												    int robot_id = ids.getInt(1);

												    String winning_bid_str = getLastString(runQuery("SELECT max_bid_amt From Auction WHERE robot_id=" + robot_id + " AND status='closed';", con));
												    
												    if (winning_bid_str == null || winning_bid_str.equalsIgnoreCase("null")) {
												    	continue;
												    }
												    float winning_bid = Float.parseFloat(winning_bid_str);
												    total_military += winning_bid;
												}
											
											} catch (Exception e) {
												e.printStackTrace();
											}
											
										    %>									
													<tr>
														<td class="left-text">
															<em>military</em>
														</td>
														<td class="right-text">
															<em>$</em> <%=total_military%>
														</td>
													</tr>
											<%
											
											%>
												</table>
											<%
										}
										
										if (user || best_users) {
											if (user) {
												%>
													<h3><em>Selling User</em></h3>
													<table class="earnings-table width-full">
												<%
											}
										
											ResultSet users = runQuery("SELECT u_id, name_user FROM Account;", con);
											
												while (users.next()) {
													String user_name = "";
													String user_id = "";
													float user_sales = 0;
													
													try {
														user_name = users.getString(2);
														user_id = users.getString(1);
														
														ResultSet user_sales_set = runQuery("SELECT SUM(max_bid_amt) FROM Auction WHERE u_id=" + user_id +" AND status='closed';", con);
														
														if (user_sales_set == null) {
															continue;
														}
														
														String user_sales_str = null;
														if (user_sales_set.next()) {
															user_sales_str = user_sales_set.getString(1);
														}
													    
													    if (user_sales_str == null) {
													    	continue;
													    }
													    
													    user_sales = Float.parseFloat(user_sales_str);
													
													} catch (Exception e) {
														e.printStackTrace();
													}
													
													top_users.add(new TopsNode(user_sales, user_name, user_id));
													
													if (user) {
												    %>									
															<tr>
																<td class="left-text">
																	<em><%=user_name%></em><%=" (User ID: " + user_id +")"%>
																</td>
																<td class="right-text">
																	<em>$</em> <%=user_sales%>
																</td>
															</tr>
													<%
													}
												}
											
											if (user) {
											
												%>
													</table>
												<%
											}
										}
									%>
								<%
							}
						%>
				    	
						<%
							if (best_items || best_users) {
								%>
									<hr>
									<h2>Best Sellers</h2>
									<%
										if (invalid_threshold) {
											%>
												<ul><li><small>Threshold: 5 (invalid input; reverted to default)</small></li></ul>
											<%
										} else {
											%>
												<ul><li><small>Threshold: <%=tops_threshold%></small></li></ul>
											<%
										}
									%>
									
									<%
										if (best_items) {
											Collections.sort(top_items);
											%>
											<h3><em>Top Items</em></h3>
											
												<table class="earnings-table width-full">
													<%
														boolean enough = true;
														for (int i = 0; i < tops_threshold; i++) {
															if (i >= top_items.size()) {
																enough = false;
																break;
															}
													%>
															<tr>
																<td class="left-text">
																	<em><%=top_items.get(i).name%></em><%=" (Item ID: " + top_items.get(i).id +")"%>
																</td>
																<td class="right-text">
																	<em>$</em> <%=top_items.get(i).sales%>
																</td>
															</tr>
															
													<%
														}
													%>
															
												</table>
											<%
											
											if (!enough) {
												%>
													<small>* <em>Not enough items on record to reach the chosen threshold</em></small>
												<%
											}
										}
									
										if (best_users) {
											Collections.sort(top_users);
											%>
											<h3><em>Top Users</em></h3>
											
											<table class="earnings-table width-full">
													<%
														boolean enough = true;
														for (int i = 0; i < tops_threshold; i++) {
															if (i >= top_users.size()) {
																enough = false;
																break;
															}
													%>
															<tr>
																<td class="left-text">
																	<em><%=top_users.get(i).name%></em><%=" (User ID: " + top_users.get(i).id +")"%>
																</td>
																<td class="right-text">
																	<em>$</em> <%=top_users.get(i).sales%>
																</td>
															</tr>
															
													<%
														}
													%>
															
												</table>
											<%
											
											if (!enough) {
												%>
													<small>* <em>Not enough users on record to reach the chosen threshold</em></small>
												<%
											}
										}
									%>
								<%
							}
						%>
				    </div>
				
				
				    <div class="height-tiny"></div>
				    <div class="center-text">
				        <a href="admincontrols.jsp"><em>Return to Admin Controls</em></a>
				    </div>
				    <div class="height-some"></div>
				    <hr>
				    <footer class="center center-text width-most">
				        <h4>
				            <em>roBay</em>, an assignment for Rutgers University CS336, Spring 2019
				        </h4>
				        <h5>
				            Group 18: Rishab Chawla, Amber Rawson, Jason Scot, Roshni Shah
				        </h5>
				    </footer>
				<%
			
            } catch (Exception e) {
            	e.printStackTrace();
            }
		} else {
			%>
				<script>
					alert("You don't have permission to view this page. Redirecting to login...");
					window.location.href = "index.jsp";
				</script>			
			<%
		}
	%>
</body>

</html>
