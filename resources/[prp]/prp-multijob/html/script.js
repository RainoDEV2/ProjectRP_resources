function exit() {
    $(document.body).fadeOut(250, function(){
        $(document.body).css('display', 'none');
    });
    $.post('https://prp-multijob/close');
}

function changeButton(id,info) {
    if (id === 'duty-button') {
        // $(`#${id}`).html(($(`#${id}`).html() === "Select") ? "<i class='bi bi-patch-check'></i>" : "Select")
        $('#duty-title').html($('#duty-title').html() === "Off Duty" ? "On Duty" : "Off Duty");
        $.post('https://prp-multijob/toggleDuty');
    } else {
        // $('#duty-button').html("Select")
        $('#duty-title').html("On Duty");
        $('.job-selectButton').each(function(index) {
            $(this).replaceWith(`<button class="button job-selectButton" id="${$(this).attr('id')}" data-grade="${$(this).data('grade')}">Select</button>`)
        })

        $(`#${id}`).replaceWith( `
            <div class="job-selectButton" id="${id}" data-grade="${info}">
                <button class="button" disabled>
                    <i class='bi bi-patch-check'></i>
                </button>
            </div>
        `)
        $.post('https://prp-multijob/changeJob', JSON.stringify({
            job: id.toString(),
            grade: info.toString()
        }));
    }
}

function populateMenu(jobs) {
    $('.jobs').html(JSON.parse(jobs).length === 0 ? '<h3 style="margin: auto;">You have no jobs</h3>':
        JSON.parse(jobs).map(job => {
            return `
            <div class="job">
                <div class="badge-info">
                    <i class="${job.icon} icon"></i>
                    <div class="job-info">
                        <h4 class="text">${job.jobLabel}</h4>
                        <h5 class="text">${job.gradeLabel}</h4>
                    </div>
                </div>
                <div class="money-select">
                    <i class="bi bi-currency-dollar job-icon"></i>
                    <h4>${job.salary}</h4>
                    <button class="button job-selectButton" id="${job.job}" data-grade="${job.grade}">Select</button>
                </div>
            </div>
        `
        })
    )
}



/* ------------------------------ end of functions ------------------------------- */

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                populateMenu(event.data.jobInfo)
                $(`#${event.data.job}`).replaceWith( `
                    <div class="job-selectButton" id="${event.data.job}" data-grade="${event.data.currentGrade}">
                        <button class="button">
                            <i class='bi bi-patch-check'></i>
                        </button>
                    </div>
                `);
                // $('#duty-button').html(event.data.duty?"Select":"<i class='bi bi-patch-check'></i>");
                $('#duty-title').html(event.data.duty ? "On Duty" : "Off Duty");
                $(document.body).fadeIn(200, function(){
                    $(document.body).css('display', 'block');
                });
                break;
        }
    })
});

$(document).on('keydown', function() {
    switch(event.key) {
        case 'Escape':
            exit();
        break;
    }
});

$(document).on("click", ".exit", function(e){
    e.preventDefault();
    exit()
})

$(document).on("click", ".button", function(e){
    e.preventDefault();
    changeButton($(this).attr('id'), $(this).data('grade'))
})
