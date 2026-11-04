<script lang="ts">
    import '../layout.css';
    import favicon from '$lib/assets/favicon.svg';
    import '../../app.css'

    let { children } = $props();
</script>
<svelte:head><link rel="icon" href={favicon} /></svelte:head>

<div class="flex justify-between items-center p-4">
    <div class="rounded-full bg-whiteblue w-15 h-15 flex justify-center items-center text-3xl text-mainblue text-center font-extrabold">J</div>
    <div class="flex justify-center items-center gap-x-2">
        <div class="rounded-full bg-mainblue w-6 h-6"></div>
        <p class="text-mainblue text-xl font-extrabold">Ticket Tout</p>
    </div>
</div>
<div class="bottom-0 fixed w-full">
    <nav class="flex justify-around bg-whiteblue rounded-2xl py-4 m-5">
        <div class="flex flex-col justify-center items-center">
            <svg width="19" height="20" viewBox="0 0 19 20" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M12 18.4167V11.0833C12 10.8402 11.9034 10.6071 11.7315 10.4352C11.5596 10.2632 11.3264 10.1667 11.0833 10.1667H7.41667C7.17355 10.1667 6.94039 10.2632 6.76849 10.4352C6.59658 10.6071 6.5 10.8402 6.5 11.0833V18.4167M1 8.33377C0.999936 8.06708 1.05806 7.80359 1.17031 7.56168C1.28255 7.31977 1.44623 7.10525 1.64992 6.93311L8.06658 1.43311C8.39749 1.15344 8.81674 1 9.25 1C9.68326 1 10.1025 1.15344 10.4334 1.43311L16.8501 6.93311C17.0538 7.10525 17.2174 7.31977 17.3297 7.56168C17.4419 7.80359 17.5001 8.06708 17.5 8.33377V16.5838C17.5 17.07 17.3068 17.5363 16.963 17.8801C16.6192 18.224 16.1529 18.4171 15.6667 18.4171H2.83333C2.3471 18.4171 1.88079 18.224 1.53697 17.8801C1.19315 17.5363 1 17.07 1 16.5838V8.33377Z" stroke="#0D2B5C" stroke-width="2" stroke-linecap="round"/></svg>
            <p class="text-mainblue text-[15px]">Acceuil</p>
        </div>
        <div class="flex flex-col justify-center items-center">
            <svg width="22" height="22" viewBox="0 0 22 22" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M19.25 14.6667H16.5C16.0138 14.6667 15.5475 14.8598 15.2036 15.2036C14.8598 15.5475 14.6667 16.0138 14.6667 16.5V19.25M19.25 19.25V19.2592M11 6.41667V9.16667C11 9.6529 10.8068 10.1192 10.463 10.463C10.1192 10.8068 9.6529 11 9.16667 11H6.41667M2.75 11H2.75917M11 2.75H11.0092M11 14.6667V14.6758M14.6667 11H15.5833M19.25 11V11.0092M11 19.25V18.3333M3.66667 2.75H6.41667C6.92293 2.75 7.33333 3.16041 7.33333 3.66667V6.41667C7.33333 6.92293 6.92293 7.33333 6.41667 7.33333H3.66667C3.16041 7.33333 2.75 6.92293 2.75 6.41667V3.66667C2.75 3.16041 3.16041 2.75 3.66667 2.75ZM15.5833 2.75H18.3333C18.8396 2.75 19.25 3.16041 19.25 3.66667V6.41667C19.25 6.92293 18.8396 7.33333 18.3333 7.33333H15.5833C15.0771 7.33333 14.6667 6.92293 14.6667 6.41667V3.66667C14.6667 3.16041 15.0771 2.75 15.5833 2.75ZM3.66667 14.6667H6.41667C6.92293 14.6667 7.33333 15.0771 7.33333 15.5833V18.3333C7.33333 18.8396 6.92293 19.25 6.41667 19.25H3.66667C3.16041 19.25 2.75 18.8396 2.75 18.3333V15.5833C2.75 15.0771 3.16041 14.6667 3.66667 14.6667Z" stroke="#666666" stroke-width="2" stroke-linecap="round"/>
            </svg>
            <p class="text-mainblue text-[15px]">Payer</p>
        </div>
        <div class="flex flex-col justify-center items-center">
            <svg width="22" height="22" viewBox="0 0 22 22" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M11.5509 19.9834C13.2557 18.5111 18.3326 13.744 18.3326 9.16665C18.3326 7.22155 17.5601 5.35612 16.1849 3.98072C14.8098 2.60533 12.9447 1.83264 11 1.83264C9.05527 1.83264 7.1902 2.60533 5.81507 3.98072C4.43994 5.35612 3.6674 7.22155 3.6674 9.16665C3.6674 13.744 8.74431 18.5111 10.4491 19.9834C10.608 20.1029 10.8013 20.1674 11 20.1674C11.1987 20.1674 11.392 20.1029 11.5509 19.9834Z" stroke="#666666" stroke-width="2" stroke-linecap="round"/>
            </svg>
            <p class="text-mainblue text-[15px]">Partenaires</p>
        </div>
    </nav>
</div>

{@render children()}
