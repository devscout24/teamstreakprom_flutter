import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../networks/api_acess.dart';
import '../model/ticket_messages_model.dart';

class SupportChatScreen extends StatefulWidget {
  final String ticketId;
  final String topic;
  final String problem;

  const SupportChatScreen({
    super.key,
    required this.ticketId,
    required this.topic,
    required this.problem,
  });

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    if (widget.ticketId.isNotEmpty) {
      _fetchMessages();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchMessages() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await getTicketMessagesRxObj.fetchTicketMessages(widget.ticketId);
      _scrollToBottom();
    } catch (_) {
      // Error handled by RxResponseInt
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || widget.ticketId.isEmpty) return;

    _messageController.clear();
    setState(() {
      _isSending = true;
    });

    try {
      await sendTicketMessageRxObj.sendTicketMessage(
        ticketId: widget.ticketId,
        message: text,
      );

      // Refresh messages list
      await getTicketMessagesRxObj.fetchTicketMessages(widget.ticketId);
      // Update my tickets list in background
      getMyTicketsRxObj.fetchMyTickets();
      _scrollToBottom();
    } catch (_) {
      // Error handled by RxResponseInt
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const CustomBackButton(),
            title: Text(
              "Streak Customer Support",
              style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<TicketMessagesResponseModel>(
              stream: getTicketMessagesRxObj.getTicketMessagesData,
              builder: (context, snapshot) {
                if (_isLoading &&
                    (!snapshot.hasData || snapshot.data?.data == null)) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColorFirst,
                    ),
                  );
                }

                if (snapshot.hasError &&
                    (!snapshot.hasData || snapshot.data?.data == null)) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 48.sp,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        UIHelper.verticalSpace(12.h),
                        Text(
                          'Failed to load conversation',
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                            fontFamily: 'SF Pro',
                            fontSize: 16.sp,
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                        UIHelper.verticalSpace(12.h),
                        TextButton(
                          onPressed: _fetchMessages,
                          child: const Text(
                            'Try Again',
                            style: TextStyle(color: AppColors.primaryColorFirst),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final messages = snapshot.data?.data?.messages ?? [];

                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'No messages yet',
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                        fontFamily: 'SF Pro',
                        fontSize: 14.sp,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 24.h,
                  ),
                  itemCount: messages.length,
                  separatorBuilder: (context, index) =>
                      UIHelper.verticalSpace(16.h),
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final text = msg.message ?? '';
                    final time = msg.formattedTime ?? msg.timeAgo;

                    if (msg.isSenderUser) {
                      return _buildRightBubble(text, time: time);
                    } else {
                      return _buildLeftBubble(
                        text,
                        senderName: msg.senderName,
                        time: time,
                      );
                    }
                  },
                );
              },
            ),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageInputField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF13151B),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1.h,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 14.h),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _messageController,
                    style:
                        TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle:
                          TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                        color: AppColors.c9B9C9A,
                        fontSize: 13.sp,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                    ),
                  ),
                ),
              ),
              UIHelper.horizontalSpace(10.w),
              GestureDetector(
                onTap: _isSending ? null : _sendMessage,
                child: Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFF28F31),
                        Color(0xFF72E84F),
                      ],
                    ),
                  ),
                  child: Center(
                    child: _isSending
                        ? SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: const CircularProgressIndicator(
                              color: Color(0xFF1E222B),
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            Icons.send_rounded,
                            color: const Color(0xFF1E222B),
                            size: 19.sp,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRightBubble(String text, {String? time}) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            constraints: BoxConstraints(maxWidth: 280.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFF28F31),
                  Color(0xFF72E84F),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
            ),
            child: Text(
              text,
              style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                color: const Color(0xFF1E222B),
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
                fontFamily: "SF Pro",
              ),
            ),
          ),
          if (time != null && time.isNotEmpty) ...[
            UIHelper.verticalSpace(4.h),
            Text(
              time,
              style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                color: AppColors.c9B9C9A,
                fontSize: 10.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLeftBubble(String text, {String? senderName, String? time}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: const BoxDecoration(
              color: Color(0xFF72E84F),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                Assets.icons.splashLogo.path,
                height: 16.h,
                color: Colors.white,
              ),
            ),
          ),
          UIHelper.horizontalSpace(8.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (senderName != null && senderName.isNotEmpty) ...[
                  Text(
                    senderName,
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                      color: AppColors.c9B9C9A,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  UIHelper.verticalSpace(4.h),
                ],
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  constraints: BoxConstraints(maxWidth: 260.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                      bottomRight: Radius.circular(24.r),
                      bottomLeft: Radius.circular(24.r),
                    ),
                  ),
                  child: Text(
                    text,
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                      color: AppColors.cBCBCBB,
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                      fontFamily: "SF Pro",
                      height: 1.4,
                    ),
                  ),
                ),
                if (time != null && time.isNotEmpty) ...[
                  UIHelper.verticalSpace(4.h),
                  Text(
                    time,
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                      color: AppColors.c9B9C9A,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
