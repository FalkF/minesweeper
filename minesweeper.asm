%include "gtkenums.inc"
%include "equates.inc"

global  main

;GTK
extern  gtk_init, gtk_window_new, gtk_button_new_with_label
extern  gtk_container_add, gtk_widget_show, gtk_main, gtk_main_quit
extern  gtk_container_set_border_width, gtk_widget_destroy
extern  gtk_window_set_position, gtk_window_set_default_size
extern  gtk_window_set_title, gtk_fixed_new, gtk_widget_set_size_request
extern  gtk_fixed_put, gtk_widget_show_all, gtk_message_dialog_new
extern  gtk_dialog_run, gtk_widget_destroy

;GLib
extern  g_signal_connect_data, g_print

SECTION .data
szPushMe            db  "2splode||!2splode", 0
szItWorks           db  "SPLODE!!!", 10 ,0
szTitle             db  "Minesweeper", 0
;event names: event_*
szevent_destroy     db  "destroy", 0
szevent_clicked     db  "clicked", 0

SECTION .bss
lpBuffer    resb    12
hMain       resd    1
hButton     resd    1
hFrame      resd    1

SECTION .text
;~ int main( int   argc,
          ;~ char *argv[] )
main:
    push    ebp
    mov     ebp, esp

    lea     eax, [ebp + 12]
    lea     ecx, [ebp + 8]
    push    eax
    push    ecx
    call    gtk_init
    add     esp, 4 * 2

    push    GTK_WINDOW_TOPLEVEL
    call    gtk_window_new
    add     esp, 4 * 1
    mov     [hMain], eax

    push    600
    push    800
    push    eax
    call    gtk_window_set_default_size
    add     esp, 4 * 3

    push    GTK_WIN_POS_CENTER
    push    dword [hMain]
    call    gtk_window_set_position
    add     esp, 4 * 2

    push    szTitle
    push    dword [hMain]
    call    gtk_window_set_title
    add     esp, 4 * 2

    call    gtk_fixed_new
    mov     [hFrame], eax

    push    eax
    push    dword [hMain]
    call    gtk_container_add
    add     esp, 4 * 2

    ; Push me button
    push    szPushMe
    call    gtk_button_new_with_label
    add     esp, 4 * 1
    mov     [hButton], eax

    push    35
    push    80
    push    eax
    call    gtk_widget_set_size_request
    add     esp, 4 * 3

    push    20
    push    100
    push    dword [hButton]
    push    dword [hFrame]
    call    gtk_fixed_put
    add     esp, 4 * 4

    ; Signals
    ; on szevent_destroy exec event_destroy
    push    NULL
    push    NULL
    push    NULL
    push    event_destroy
    push    szevent_destroy
    push    dword [hMain]
    call    g_signal_connect_data
    add     esp, 4 * 6
    ; push button on szevent_clicked exec event_clicked
    push    NULL
    push    NULL
    push    NULL
    push    event_clicked
    push    szevent_clicked
    push    dword [hButton]
    call    g_signal_connect_data
    add     esp, 4 * 6
    ; show window?
    push    dword [hMain]
    call    gtk_widget_show_all
    add     esp, 4 * 1

    call    gtk_main ; exec gtk main routine

    mov     esp, ebp
    pop     ebp
    ret

;~ void event_destroy( GtkWidget *widget,
                    ;~ gpointer   data )
event_destroy:
    call    gtk_main_quit
    ret

;~ void event_clicked( GtkWidget *widget,
                    ;~ gpointer   data )
event_clicked:
    push    szItWorks
    call    g_print
    add     esp, 4 * 1
    ret
