<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style type="text/css">
.body-container {
	max-width: 800px;
}
.nav-tabs .nav-link {
	min-width: 170px;
	background: #f3f5f7;
	border-radius: 0;
	border-right: 1px solid #dbdddf;
	color: #333;
	font-weight: 600;
}
.nav-tabs .nav-link.active {
	background: #3d3d4f;
	color: #fff;
}
.tab-pane { min-height: 300px; }

.dialog-receiver-list {
	height: 200px;
	overflow-y: scroll;
}
.dialog-receiver-list ul, .dialog-receiver-list li {
	list-style: none;
	padding: 0;
}

.receiver-user {
	color: #0d58ba;
	margin-right: 3px;
	cursor: pointer;
}
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/boot-board.css" type="text/css">

<script type="text/javascript">
$(function(){
    $("button[role='tab']").on("click", function(e){
		let tab = $(this).attr("data-tab");
		if(tab === "send") {
			return false;
		}		
		let url = "${pageContext.request.contextPath}/note/receive/list";
		location.href=url;
    });
});

function sendOk() {
	const f = document.noteForm;
	let str;

	if($("#forms-receiver-list input[name=receivers]").length === 0) {
		alert("받는 사람을 추가하세요. ");
		return;
	}

	str = f.content.value.trim();
	if(!str) {
		alert("내용을 입력하세요. ");
		f.content.focus();
		return;
	}

	f.action="${pageContext.request.contextPath}/note/write";

	f.submit();
}
</script>

<div class="container">
	<div class="body-container">	
		<div class="body-title">
			<h3><i class="bi bi-messenger"></i> 쪽지함 </h3>
		</div>
		
		<div class="body-main">
			<ul class="nav nav-tabs" id="myTab" role="tablist">
				<li class="nav-item" role="presentation">
					<button class="nav-link" id="tab-receive" data-bs-toggle="tab" data-bs-target="#nav-content" type="button" role="tab" aria-controls="receive" aria-selected="true" data-tab="receive">받은 쪽지함</button>
				</li>
				<li class="nav-item" role="presentation">
					<button class="nav-link active" id="tab-send" data-bs-toggle="tab" data-bs-target="#nav-content" type="button" role="tab" aria-controls="send" aria-selected="true" data-tab="send">보낸 쪽지함</button>
				</li>
			</ul>
			
			<div class="tab-content pt-2" id="nav-tabContent">
				<div class="tab-pane fade show active mt-3" id="nav-content" role="tabpanel" aria-labelledby="nav-tab-content">
				
					<form name="noteForm" method="post">
						<table class="table mt-5 write-form">
							<tr>
								<td class="bg-light col-sm-2" scope="row">받는사람</td>
								<td>
									<c:choose>
										<c:when test="${sessionScope.member.membership>50}">
											<div class="row">
												<div class="col-auto pe-0">
													<button type="button" class="btn btn-light btnReceiverDialog">추가</button>
												</div>
												<div class="col">
													<div class="forms-receiver-name"></div>
												</div>
											</div>
											<small class="form-control-plaintext">한번에 보낼수 있는 최대 인원은 5명입니다.</small>
										</c:when>
										<c:otherwise>
											<p class="form-control-plaintext">관리자</p>
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
		        
							<tr>
								<td class="bg-light col-sm-2" scope="row">내 용</td>
								<td>
									<textarea name="content" id="content" class="form-control">${dto.content}</textarea>
								</td>
							</tr>
							
						</table>
						
						<table class="table table-borderless">
		 					<tr>
								<td class="text-center">
									<button type="button" class="btn btn-dark" onclick="sendOk();">보내기&nbsp;<i class="bi bi-check2"></i></button>
									<button type="reset" class="btn btn-light">다시입력</button>
									<button type="button" class="btn btn-light" onclick="location.href='${pageContext.request.contextPath}/note/send/list';">취소&nbsp;<i class="bi bi-x"></i></button>
									<div id="forms-receiver-list">
										<c:if test="${sessionScope.member.membership<51}">
											<input type="hidden" name="receivers" value="1">
										</c:if>
									</div>
								</td>
							</tr>
						</table>
					</form>
				
				</div>
			</div>		
		
		</div>
	</div>
</div>

<c:if test="${sessionScope.member.membership>50}">
	<div class="modal fade" id="myDialogModal" tabindex="-1" 
			data-bs-backdrop="static" data-bs-keyboard="false"
			aria-labelledby="myDialogModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="myDialogModalLabel">받는 사람</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-auto p-1">
							<select name="schType" id="schType" class="form-select">
								<option value="userName">이름</option>
								<option value="userId">아이디</option>
							</select>
						</div>
						<div class="col-auto p-1">
							<input type="text" name="kwd" id="kwd" class="form-control">
						</div>
						<div class="col-auto p-1">
							<button type="button" class="btn btn-light btnReceiverFind"> <i class="bi bi-search"></i> </button>
						</div>				
					</div>
					<div class="row p-1">
						<div class="border p-1 dialog-receiver-list">
							<ul></ul>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary btnAdd">추가</button>
					<button type="button" class="btn btn-secondary btnClose">닫기</button>
				</div>			
			</div>
		</div>
	</div>

	<script type="text/javascript">
		function login() {
			location.href = '${pageContext.request.contextPath}/member/login';
		}
		
		function ajaxFun(url, method, formData, dataType, fn, file = false) {
			const settings = {
					type: method, 
					data: formData,
					dataType:dataType,
					success:function(data) {
						fn(data);
					},
					beforeSend: function(jqXHR) {
						jqXHR.setRequestHeader('AJAX', true);
					},
					complete: function () {
					},
					error: function(jqXHR) {
						if(jqXHR.status === 403) {
							login();
							return false;
						} else if(jqXHR.status === 400) {
							alert('요청 처리가 실패 했습니다.');
							return false;
				    	}
				    	
						console.log(jqXHR.responseText);
					}
			};
			
			if(file) {
				settings.processData = false;  // file 전송시 필수. 서버로전송할 데이터를 쿼리문자열로 변환여부
				settings.contentType = false;  // file 전송시 필수. 서버에전송할 데이터의 Content-Type. 기본:application/x-www-urlencoded
			}
			
			$.ajax(url, settings);
		}
		
		$(function(){
			$(".btnReceiverDialog").click(function(){
				$("#schType").val("userName");
				$("#kwd").val("");
				$(".dialog-receiver-list ul").empty();
				
				$("#myDialogModal").modal("show");
			});
			
			// 대화상자 - 받는사람 검색 버튼
			$(".btnReceiverFind").click(function(){
				let schType = $("#schType").val();
				let kwd = $("#kwd").val();
				if(! kwd) {
					$("#kwd").focus();
					return false;
				}
				
				let url = "${pageContext.request.contextPath}/note/listMember"; 
				let query = "schType="+schType+"&kwd="+encodeURIComponent(kwd);
				
				const fn = function(data){
					if(data.state === "false") {
						return false;
					}
					
					$(".dialog-receiver-list ul").empty();
					searchListMember(data);
				};
				ajaxFun(url, "get", query, "json", fn);
			});
			
			function searchListMember(data) {
				let s;
				for(let i=0; i<data.listMember.length; i++) {
					let memberIdx = data.listMember[i].memberIdx;
					let userId = data.listMember[i].userId;
					let userName = data.listMember[i].userName;
					
					s = "<li><input type='checkbox' class='form-check-input' data-memberIdx='"+memberIdx+"' title='"+userId+"'> <span>"+userName+"</span></li>";
					$(".dialog-receiver-list ul").append(s);
				}
			}
			
			// 대화상자-받는 사람 추가 버튼
			$(".btnAdd").click(function(){
				let len1 = $(".dialog-receiver-list ul input[type=checkbox]:checked").length;
				let len2 = $("#forms-receiver-list input[name=receivers]").length;
				
				if(len1 === 0) {
					alert("추가할 사람을 먼저 선택하세요.");
					return false;			
				}
				
				if(len1 + len2 >= 5) {
					alert("받는사람은 최대 5명까지만 가능합니다.");
					return false;
				}
				
				let b, memberIdx, userName, s;
		
				b = false;
				$(".dialog-receiver-list ul input[type=checkbox]:checked").each(function(){
					memberIdx = $(this).attr("data-memberIdx");
					userName = $(this).next("span").text();
					
					$("#forms-receiver-list input[name=receivers]").each(function(){
						if($(this).val() === memberIdx) {
							b = true;
							return false;
						}
					});
					
					if(! b) {
						s = "<span class='receiver-user btn border px-1'>"+userName+" <i class='bi bi-trash' data-memberIdx='"+memberIdx+"'></i></span>";
						$(".forms-receiver-name").append(s);
						
						s = "<input type='hidden' name='receivers' value='"+memberIdx+"'>";
						$("#forms-receiver-list").append(s);
					}
				});
				
				$("#myDialogModal").modal("hide");
			});
			
			$(".btnClose").click(function(){
				$("#myDialogModal").modal("hide");
			});
			
			$("body").on("click", ".bi-trash", function(){
				let memberIdx = $(this).attr("data-memberIdx");
				
				$(this).parent().remove();
				$("#forms-receiver-list input[name=receivers]").each(function(){
					let receiver = $(this).val();
					if(memberIdx === receiver) {
						$(this).remove();
						return false;
					}
				});
				
			});
		
		});
	</script>
</c:if>