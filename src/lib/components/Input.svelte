<script>
    let {
        value = $bindable(''),
        type = 'text',
        id = '',
        label = '',
        placeholder = '',
        icon = '',
        iconAlt = 'icon',
        class: extraClass = ''
    } = $props();
</script>

<div class="w-full">
    {#if label}
        <p class="text-white font-[Mariane] mb-1">{label}</p>
    {/if}
    <div class="border border-white/40 w-full rounded-2xl bg-white/10 flex p-3 gap-x-2 items-center">
        {#if icon}
            <img src={icon} alt={iconAlt} class="w-5 h-5" />
        {/if}
        <input {id} {type} {placeholder} bind:value={value} class="bg-transparent text-white  outline-none w-full {extraClass}"/>
    </div>
</div>